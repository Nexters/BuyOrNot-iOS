//
//  UserRepository.swift
//  Domain
//
//  Created by 문종식 on 2/15/26.
//

public protocol UserRepository {
    func cacheUser(_ user: User)
    func clearCachedUser()
    func getMe() async throws -> User
    func getCachedUser() -> User?
    func updateFCMToken(_ token: String) async throws
    func deleteAccount() async throws
    func blockUser(userId: Int) async throws
    func getBlockedUsers() async throws -> [BlockedUser]
    func unblockUser(userId: Int) async throws
}
