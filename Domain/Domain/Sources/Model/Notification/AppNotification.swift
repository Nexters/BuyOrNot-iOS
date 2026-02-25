//
//  Notification.swift
//  Domain
//
//  Created by 이조은 on 2/25/26.
//

import Foundation

public struct AppNotification {
    public let notificationId: Int
    public let feedId: Int
    public let type: AppNotificationType
    public let title: String
    public let body: String
    public let isRead: Bool
    public let voteClosedAt: DateComponents
    public let resultPercent: Int
    public let resultLabel: ResultLabel
    public let viewUrl: String?

    public init(notificationId: Int, feedId: Int, type: AppNotificationType, title: String, body: String, isRead: Bool, voteClosedAt: DateComponents, resultPercent: Int, resultLabel: ResultLabel, viewUrl: String?) {
        self.notificationId = notificationId
        self.feedId = feedId
        self.type = type
        self.title = title
        self.body = body
        self.isRead = isRead
        self.voteClosedAt = voteClosedAt
        self.resultPercent = resultPercent
        self.resultLabel = resultLabel
        self.viewUrl = viewUrl
    }
}
