//
//  NotificationResponse.swift
//  Service
//
//  Created by 이조은 on 2/25/26.
//

import Foundation

struct NotificationResponse: Decodable {
    let notificationId: Int
    let feedId: Int
    let type: String
    let title: String
    let body: String
    let isRead: Bool
    let voteClosedAt: String
    let resultPercent: Int
    let resultLabel: String
    let viewUrl: String?
}
