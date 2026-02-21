//
//  GoogleAuth.swift
//  Auth
//
//  Created by 문종식 on 2/13/26.
//

import Foundation
import GoogleSignIn
import Core

struct GoogleAuth {
    private var clientID: String? {
        let key: String = "CLIENT_ID"
        let bundleObject = Bundle.main.object(
            forInfoDictionaryKey: key
        )
        return bundleObject as? String
    }
    
    public func requestLogin(
        _ completeHandler: @escaping (GIDSignInResult?) -> Void
    ) {
        guard let clientID else {
#if DEBUG
            print("🚨 Google Login: Client ID is nil.")
#endif
            completeHandler(nil)
            return
        }
        
        guard let presentingViewController = Utils.topViewController else {
#if DEBUG
            print("🚨 Google Login: presentingViewController is nil.")
#endif
            completeHandler(nil)
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: clientID
        )
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        ) { result, error in
            if let error {
#if DEBUG
                print("🚨 Google Login: \(error)")
#endif
                completeHandler(nil)
                return
            }
            guard let result else {
#if DEBUG
                print("🚨 Google Login: GIDSignInResult is nil.")
#endif
                completeHandler(nil)
                return
            }
            completeHandler(result)
        }
    }
}
