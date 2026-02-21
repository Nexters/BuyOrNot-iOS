//
//  LoginDelegate.swift
//  Auth
//
//  Created by 문종식 on 2/21/26.
//

import Domain

public protocol LoginDelegate {
    func completeLogin(_ result: AuthState)
}
