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
    
    public func getMe() async throws -> User {
        if let user = userStore.getUser() {
            return user
        }
        let response: BaseResponse<UserResponse> = try await request(.getMe)
        let data = response.data.toDomain()
        userStore.saveUser(data)
        return data
    }

    public func getCachedUser() -> User? {
        userStore.getUser()
    }
    
    public func deleteAccount() async throws {
        try await request(.deleteMe)
        userStore.removeUser()
    }
}
