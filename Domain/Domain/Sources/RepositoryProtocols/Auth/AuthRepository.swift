//
//  AuthRepository.swift
//  Domain
//
//  Created by 문종식 on 2/14/26.
//

public protocol AuthRepository {
    func loginWithApple(authorizationCode: String) async throws -> Token
    func loginWithGoogle(idToken: String) async throws -> Token
    func loginWithKakao(accessToken: String) async throws -> Token
    func refreshToken(refreshToken: String) async throws -> Token
    func logout(refreshToken: String) async throws
}
