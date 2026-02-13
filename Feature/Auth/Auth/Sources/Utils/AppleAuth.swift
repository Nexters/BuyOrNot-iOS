//
//  AppleAuth.swift
//  Auth
//
//  Created by Codex on 2/13/26.
//

import AuthenticationServices
import Core
import UIKit

struct AppleAuth {
    private let delegate = AppleLoginDelegate()
    
    public func requestLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = delegate
        controller.presentationContextProvider = delegate
        controller.performRequests()
    }
}

struct AppleLoginPayload {
    let identityToken: String
    let authorizationCode: String
    let userID: String
    let email: String?
    let fullName: PersonNameComponents?
}

private final class AppleLoginDelegate: NSObject {
    private enum AppleLoginError: LocalizedError {
        case invalidCredential
        case missingIdentityToken
        case missingAuthorizationCode
        
        var errorDescription: String? {
            switch self {
            case .invalidCredential:
                "Apple credential is invalid."
            case .missingIdentityToken:
                "Apple identity token is missing."
            case .missingAuthorizationCode:
                "Apple authorization code is missing."
            }
        }
    }
    
    private func handleAppleLoginSuccess(
        _ credential: ASAuthorizationAppleIDCredential
    ) {
        guard let identityToken = credential.identityToken,
              let identityTokenString = String(data: identityToken, encoding: .utf8),
              !identityTokenString.isEmpty else {
            /// TODO 에러 처리 필요 AppleLoginError.missingIdentityToken
            return
        }
        
        guard let authorizationCode = credential.authorizationCode,
              let authorizationCodeString = String(data: authorizationCode, encoding: .utf8),
              !authorizationCodeString.isEmpty else {
            /// TODO 에러 처리 필요 AppleLoginError.missingAuthorizationCode
            return
        }
        
        print(
            "Apple Login Success:\n" +
            "identityToken(\(identityTokenString.count))\n" +
            "authorizationCode(\(authorizationCodeString.count))\n" +
            "user(\(credential.user))"
        )
        
        let payload = AppleLoginPayload(
            identityToken: identityTokenString,
            authorizationCode: authorizationCodeString,
            userID: credential.user,
            email: credential.email,
            fullName: credential.fullName
        )
        // TODO: authorizationCodeString 전달
        print(payload)
    }
}

extension AppleLoginDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            /// TODO 에러 처리 필요 AppleLoginError.invalidCredential
            return
        }
        if let d = authorization.provider as? ASAuthorizationAppleIDProvider {
            d.createRequest()
        }
        
        handleAppleLoginSuccess(credential)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        /// TODO 에러 처리 필요
    }
}

extension AppleLoginDelegate: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let window = Utils.topViewController?.view.window {
            return window
        }
        
        if let retryWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap(\.windows)
            .first(where: { $0.isKeyWindow }) {
            return retryWindow
        }
        
        return ASPresentationAnchor()
    }
}
