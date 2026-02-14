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
            completeHandler(result)
        }
    }
}
