//
//  NotificationRepository.swift
//  Domain
//
//  Created by 이조은 on 2/25/26.
//

public protocol NotificationRepository {
    func getNotifications(type: String?) async throws -> [AppNotification]
}
