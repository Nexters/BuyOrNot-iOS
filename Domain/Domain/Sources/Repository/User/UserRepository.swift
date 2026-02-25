//
//  UserRepository.swift
//  Domain
//
//  Created by 문종식 on 2/15/26.
//

public protocol UserRepository {
    func getMe() async throws -> User
    func getCachedUser() -> User?
    func deleteAccount() async throws
}
