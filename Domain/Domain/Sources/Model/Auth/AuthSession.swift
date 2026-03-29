//
//  AuthSession.swift
//  Domain
//
//  Created by 문종식 on 3/29/26.
//

public struct AuthSession {
    public let token: Token
    public let user: User

    public init(token: Token, user: User) {
        self.token = token
        self.user = user
    }
}
