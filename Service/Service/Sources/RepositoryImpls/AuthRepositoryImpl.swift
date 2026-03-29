//
//  AuthRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

public class AuthRepositoryImpl: AuthRepository {
    private let apiClient: NetworkClientProtocol
    
    public init() {
        self.apiClient = NetworkClient.shared
    }
    
    private func request<T: Decodable>(_ endpoint: AuthEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    public func loginWithApple(authorizationCode: String) async throws -> AuthSession {
        let body = AppleAuthRequest(
            authorizationCode: authorizationCode
        )
        let response: BaseResponse<AuthSessionResponse> = try await request(
            .postAppleLogin(body)
        )
        return response.data.toDomain()
    }
    
    public func loginWithGoogle(idToken: String) async throws -> AuthSession {
        let body = GoogleAuthRequest(
            idToken: idToken
        )
        let response: BaseResponse<AuthSessionResponse> = try await request(
            .postGoogleLogin(body)
        )
        return response.data.toDomain()
    }
    
    public func loginWithKakao(accessToken: String) async throws -> AuthSession {
        let body = KakaoAuthRequest(
            accessToken: accessToken
        )
        let response: BaseResponse<AuthSessionResponse> = try await request(
            .postKakaoLogin(body)
        )
        return response.data.toDomain()
    }
    
    public func refreshToken(refreshToken: String) async throws -> AuthSession {
        let body = RefreshTokenRequest(
            refreshToken: refreshToken
        )
        let response: BaseResponse<AuthSessionResponse> = try await request(
            .postRefreshToken(body)
        )
        return response.data.toDomain()
    }
    
    public func logout(refreshToken: String) async throws {
        let body = LogoutRequest(
            refreshToken: refreshToken
        )
        try await apiClient.request(
            AuthEndpoint.postLogout(body)
        )
    }
}
