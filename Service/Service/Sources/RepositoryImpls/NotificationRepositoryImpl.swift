//
//  NotificationRepositoryImpl.swift
//  Service
//
//  Created by 이조은 on 2/25/26.
//

import Domain
import Foundation

public class NotificationRepositoryImpl: NotificationRepository {
    private let apiClient: NetworkClientProtocol

    public init() {
        self.apiClient = NetworkClient.shared
    }

    private func request<T: Decodable>(_ endpoint: NotificationEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }

    public func getNotifications(type: String?) async throws -> [AppNotification] {
        let response: BaseResponse<[NotificationResponse]> = try await request(
            .getNotifications(type: type)
        )
        return response.data.map { $0.toDomain() }
    }

    public func patchNotificationRead(id: String) async throws {
        let _: BaseResponse<EmptyResponse> = try await request(
            .patchNotificationRead(id: id)
        )
    }

    public func getNotificationUnreadCount() async throws -> Int {
        let response: BaseResponse<NotificationUnreadCountResponse> = try await request(
            .getNotificationUnreadCount
        )
        return response.data.unreadCount
    }
}
