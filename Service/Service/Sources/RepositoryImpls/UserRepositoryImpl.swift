//
//  UserRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/15/26.
//

import Domain

public class UserRepositoryImpl: UserRepository {
    private let apiClient: NetworkClient
    
    public init() {
        self.apiClient = .shared
    }
    
    private func request<T: Decodable>(_ endpoint: UserEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    private func request(_ endpoint: UserEndpoint) async throws {
        try await apiClient.request(endpoint)
    }
    
    public func getMe() async throws -> User {
        let response: UserResponse = try await request(.getMe)
        return response.toDomain()
    }
    
    public func deleteAccount() async throws {
        try await request(.deleteMe)
    }
}
