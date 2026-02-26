//
//  NotificationResponse+Extension.swift
//  Service
//
//  Created by 이조은 on 2/25/26.
//

import Domain
import Foundation

extension NotificationResponse {
    func toDomain() -> AppNotification {
        AppNotification(
            notificationId: self.notificationId,
            feedId: self.feedId,
            type: AppNotificationType(rawValue: self.type) ?? .myFeedClosed,
            title: self.title,
            body: self.body,
            isRead: self.isRead,
            voteClosedAt: toDateComponents(from: self.voteClosedAt),
            resultPercent: self.resultPercent,
            resultLabel: ResultLabel(rawValue: self.resultLabel) ?? .zero,
            viewUrl: self.viewUrl
        )
    }

    private func toDateComponents(from dateString: String) -> DateComponents {
        guard let date = parseISO8601Date(dateString) else {
            return DateComponents()
        }
        return Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
    }

    private func parseISO8601Date(_ value: String) -> Date? {
        if let date = getISO8601Formatter([.withInternetDateTime, .withFractionalSeconds]).date(from: value) ??
            getISO8601Formatter([.withInternetDateTime]).date(from: value) {
            return date
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = formatter.date(from: value) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: value)
    }

    private func getISO8601Formatter(_ formatOptions: ISO8601DateFormatter.Options) -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = formatOptions
        return formatter
    }
}
