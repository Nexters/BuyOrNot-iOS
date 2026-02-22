//
//  AuthRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

public class AuthRepositoryImpl: AuthRepository {
    private let apiClient: NetworkClientProtocol
    private let tokenStore: TokenStore
    private let userStore: UserStore
    
    public init() {
        self.apiClient = NetworkClient.shared
        self.tokenStore = TokenStore()
        self.userStore = UserStore()
    }
    
    private func request<T: Decodable>(_ endpoint: AuthEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    public func loginWithApple(authorizationCode: String) async throws -> Token {
        let body = AppleAuthRequest(
            authorizationCode: authorizationCode
        )
        let response: BaseResponse<TokenResponse> = try await request(
            .postAppleLogin(body)
        )
        saveToStore(response.data)
        return response.data.toToken()
    }
    
    public func loginWithGoogle(idToken: String) async throws -> Token {
        let body = GoogleAuthRequest(
            idToken: idToken
        )
        let response: BaseResponse<TokenResponse> = try await request(
            .postGoogleLogin(body)
        )
        saveToStore(response.data)
        return response.data.toToken()
    }
    
    public func loginWithKakao(accessToken: String) async throws -> Token {
        let body = KakaoAuthRequest(
            accessToken: accessToken
        )
        let response: BaseResponse<TokenResponse> = try await request(
            .postKakaoLogin(body)
        )
        saveToStore(response.data)
        return response.data.toToken()
    }
    
    public func refreshToken(refreshToken: String) async throws -> Token {
        let body = RefreshTokenRequest(
            refreshToken: refreshToken
        )
        let response: BaseResponse<TokenResponse> = try await request(
            .postRefreshToken(body)
        )
        saveToStore(response.data)
        return response.data.toToken()
    }
    
    public func logout(refreshToken: String) async throws {
        let body = LogoutRequest(
            refreshToken: refreshToken
        )
        try await apiClient.request(
            AuthEndpoint.postLogout(body)
        )
        tokenStore.removeToken()
        userStore.removeUser()
    }
    
    private func saveToStore(_ data: TokenResponse) {
        tokenStore.saveToken(data.toToken())
        userStore.saveUser(data.toUser())
    }
}
