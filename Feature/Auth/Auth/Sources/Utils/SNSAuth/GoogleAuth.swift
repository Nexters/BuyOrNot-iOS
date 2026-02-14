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
    
    public func requestLogin(
        _ completeHandler: @escaping (GIDSignInResult?) -> Void
    ) {
        guard let clientID = auth.getAPIKey(with: .google),
              !clientID.isEmpty else {
            completeHandler(nil)
            return
        }
        
        guard let presentingViewController = Utils.topViewController else {
            completeHandler(nil)
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: clientID
        )
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        ) { result, error in
            guard let result else { return }
            completeHandler(result)
        }
    }
}
