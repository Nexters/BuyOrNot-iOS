//
//  TokenRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

public final class TokenRepositoryImpl: TokenRepository {
    private let tokenStore: TokenStore
    
    public init() {
        self.tokenStore = TokenStore()
    }
    
    public func saveToken(_ token: Token) {
        tokenStore.saveToken(token)
    }
    
    public func getToken() -> Token {
        tokenStore.getToken() ?? .empty
    }
    
    public func removeToken() {
        tokenStore.removeToken()
    }
}
