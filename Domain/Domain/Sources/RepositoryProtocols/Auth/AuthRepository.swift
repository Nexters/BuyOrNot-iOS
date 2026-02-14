//
//  AuthRepository.swift
//  Domain
//
//  Created by 문종식 on 2/14/26.
//

public protocol AuthRepository {
    func loginWithApple(authorizationCode: String) async throws -> User
    func loginWithGoogle(idToken: String) async throws -> User
    func loginWithKakao(accessToken: String) async throws -> User
    func refreshToken(refreshToken: String) async throws -> User
    func logout(refreshToken: String) async throws
}
