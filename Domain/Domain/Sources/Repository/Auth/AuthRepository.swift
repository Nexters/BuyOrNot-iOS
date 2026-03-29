//
//  AuthRepository.swift
//  Domain
//
//  Created by 문종식 on 2/14/26.
//

public protocol AuthRepository {
    func loginWithApple(authorizationCode: String) async throws -> AuthSession
    func loginWithGoogle(idToken: String) async throws -> AuthSession
    func loginWithKakao(accessToken: String) async throws -> AuthSession
    func refreshToken(refreshToken: String) async throws -> AuthSession
    func logout(refreshToken: String) async throws
}
