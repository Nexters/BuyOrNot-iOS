//
//  GoogleAuth.swift
//  Auth
//
//  Created by 문종식 on 2/13/26.
//

import GoogleSignIn
import Core

struct GoogleAuth {
    private let auth = Auth()
    
    public func requestLogin() {
        guard let clientID = auth.getAPIKey(with: .google),
              !clientID.isEmpty else {
            return
        }
        
        guard let presentingViewController = Utils.topViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: clientID
        )
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        ) { result, error in
            guard let result else { return }
            handleGoogleLoginSuccess(result)
        }
    }
    
    private func handleGoogleLoginSuccess(_ result: GIDSignInResult) {
        let idToken = result.user.idToken?.tokenString ?? ""
        let accessToken = result.user.accessToken.tokenString
        print("Google Login Success: idToken(\(idToken.count)) accessToken(\(accessToken.count))")
        // TODO: idToken 전달
    }
}
