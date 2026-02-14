//
//  AuthRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

public class AuthRepositoryImpl: AuthRepository {
    private let apiClient: NetworkClient = .shared
    private let mapper = AuthMapper()
    
    private func request<T: Decodable>(_ endpoint: AuthEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    public func loginWithApple(authorizationCode: String) async throws -> User {
        let body = AppleAuthRequest(
            authorizationCode: authorizationCode
        )
        let response: TokenResponse = try await request(
            .appleLogin(body)
        )
        return mapper.toDomain(response)
    }
    
    public func loginWithGoogle(idToken: String) async throws -> User {
        let body = GoogleAuthRequest(
            idToken: idToken
        )
        let response: TokenResponse = try await request(
            .googleLogin(body)
        )
        return mapper.toDomain(response)
    }
    
    public func loginWithKakao(accessToken: String) async throws -> User {
        let body = KakaoAuthRequest(
            accessToken: accessToken
        )
        let response: TokenResponse = try await request(
            .kakaoLogin(body)
        )
        return mapper.toDomain(response)
    }
    
    public func refreshToken(refreshToken: String) async throws -> User {
        let body = RefreshTokenRequest(
            refreshToken: refreshToken
        )
        let response: TokenResponse = try await request(
            .refreshToken(body)
        )
        return mapper.toDomain(response)
    }
    
    public func logout(refreshToken: String) async throws {
        let body = LogoutRequest(
            refreshToken: refreshToken
        )
        try await apiClient.request(
            AuthEndpoint.logout(body)
        )
    }
}
