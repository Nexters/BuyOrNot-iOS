//
//  AppleAuth.swift
//  Auth
//
//  Created by 문종식 on 2/13/26.
//

import AuthenticationServices
import Core
import UIKit

struct AppleAuth {
    static private var delegate: AppleLoginDelegate?
    
    func clearDelegate() {
        Self.delegate = nil
    }
    
    func requestLogin(
        _ completeHandler: @escaping (String?) -> Void
    ) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        AppleAuth.delegate = AppleLoginDelegate(completeHandler)
        guard let delegate = AppleAuth.delegate else {
            completeHandler(nil)
            return
        }
        controller.delegate = delegate
        controller.presentationContextProvider = delegate
        controller.performRequests()
    }
}

private final class AppleLoginDelegate: NSObject {
    var completion: ((String?) -> Void)?
    
    init(_ completion: ((String?) -> Void)?) {
        self.completion = completion
    }
    
    private func handleAppleLoginSuccess(
        _ credential: ASAuthorizationAppleIDCredential
    ) {
        guard let authorizationCode = credential.authorizationCode?.toString else {
            completion?(nil)
            return
        }
        completion?(authorizationCode)
    }
}

extension AppleLoginDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            completion?(nil)
            return
        }
        handleAppleLoginSuccess(credential)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        completion?(nil)
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
