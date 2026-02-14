//
//  LocalRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

public final class LocalRepositoryImpl: LocalRepository {
    private let tokenService: TokenService
    private let mapper: TokenMapper
    
    public init() {
        self.tokenService = TokenService()
        self.mapper = TokenMapper()
    }
    
    public func saveToken(_ token: Token) {
        tokenService.saveRefreshToken(token.refreshToken)
        tokenService.saveAccessToken(token.accessToken)
    }
    
    public func getToken() -> Token {
        let refreshToken = tokenService.getRefreshToken() ?? ""
        let accessToken = tokenService.getAccessToken() ?? ""
        return Token(
            refreshToken: refreshToken,
            accessToken: accessToken
        )
    }
    
    public func removeToken() {
        tokenService.removeRefreshToken()
        tokenService.removeAccessToken()
    }
}
