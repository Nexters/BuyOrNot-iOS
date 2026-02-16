//
//  LocalRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

public final class LocalRepositoryImpl: LocalRepository {
    private let tokenService: TokenService
    
    public init() {
        self.tokenService = TokenService()
    }
    
    public func saveToken(_ token: Token) {
        tokenService.saveRefreshToken(token.refreshToken)
        tokenService.saveAccessToken(token.accessToken)
        tokenService.saveTokenType(token.tokenType)
    }
    
    public func getToken() -> Token {
        Token(
            refreshToken: tokenService.getRefreshToken() ?? "",
            accessToken: tokenService.getAccessToken() ?? "",
            tokenType: tokenService.getTokenType() ?? ""
        )
    }
    
    public func removeToken() {
        tokenService.removeRefreshToken()
        tokenService.removeAccessToken()
        tokenService.removeTokenType()
    }
}
