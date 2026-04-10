//
//  UserRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/15/26.
//

import Domain

public class UserRepositoryImpl: UserRepository {
    private let apiClient: NetworkClientProtocol
    private let userStore: UserStore
    
    public init() {
        self.apiClient = NetworkClient.shared
        self.userStore = UserStore()
    }
    
    private func request<T: Decodable>(_ endpoint: UserEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    private func request(_ endpoint: UserEndpoint) async throws {
        try await apiClient.request(endpoint)
    }
    
    public func cacheUser(_ user: User) {
        userStore.saveUser(user)
    }

    public func clearCachedUser() {
        userStore.removeUser()
    }

    public func getMe() async throws -> User {
        let response: BaseResponse<UserResponse> = try await request(.getMe)
        let data = response.data.toDomain()
        userStore.saveUser(data)
        return data
    }

    public func getCachedUser() -> User? {
        userStore.getUser()
    }

    public func updateFCMToken(_ token: String) async throws {
        let body = UpdateFCMTokenRequest(fcmToken: token)
        try await request(.patchFcmToken(body))
    }
    
    public func deleteAccount() async throws {
        try await request(.deleteMe)
        userStore.removeUser()
    }

    public func blockUser(userId: Int) async throws {
        try await request(.blockUser(userId))
    }

    public func getBlockedUsers() async throws -> [BlockedUser] {
        let response: BaseResponse<[BlockedUserResponse]> = try await request(.getBlockedUsers)
        return response.data.map { $0.toDomain() }
    }

    public func unblockUser(userId: Int) async throws {
        try await request(.unblockUser(userId))
    }
}
