//
//  AuthRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

public class AuthRepositoryImpl: AuthRepository {
    private let apiClient: NetworkClientProtocol
    private let tokenService: TokenService
    
    public init() {
        self.apiClient = NetworkClient.shared
        self.tokenService = TokenService()
    }
    
    private func request<T: Decodable>(_ endpoint: AuthEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    public func loginWithApple(authorizationCode: String) async throws -> Token {
        let body = AppleAuthRequest(
            authorizationCode: authorizationCode
        )
        let response: TokenResponse = try await request(
            .postAppleLogin(body)
        )
        return response.toToken()
    }
    
    public func loginWithGoogle(idToken: String) async throws -> Token {
        let body = GoogleAuthRequest(
            idToken: idToken
        )
        let response: TokenResponse = try await request(
            .postGoogleLogin(body)
        )
        return response.toToken()
    }
    
    public func loginWithKakao(accessToken: String) async throws -> Token {
        let body = KakaoAuthRequest(
            accessToken: accessToken
        )
        let response: TokenResponse = try await request(
            .postKakaoLogin(body)
        )
        return response.toToken()
    }
    
    public func refreshToken(refreshToken: String) async throws -> Token {
        let body = RefreshTokenRequest(
            refreshToken: refreshToken
        )
        let response: TokenResponse = try await request(
            .postRefreshToken(body)
        )
        return response.toToken()
    }
    
    public func logout(refreshToken: String) async throws {
        let body = LogoutRequest(
            refreshToken: refreshToken
        )
        try await apiClient.request(
            AuthEndpoint.postLogout(body)
        )
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
