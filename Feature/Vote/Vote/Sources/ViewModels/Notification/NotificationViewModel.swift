//
//  NotificationViewModel.swift
//  Vote
//
//  Created by 이조은 on 2/25/26.
//

import SwiftUI
import Domain

public struct NotificationItemData: Identifiable {
    public let id: String
    public let imageURL: String
    public let status: String
    public let message: String
    public let timeAgo: String
    public let isRead: Bool
    public let feedId: Int
}

public final class NotificationViewModel: ObservableObject {
    private let notificationRepository: NotificationRepository
    private let navigator: VoteNavigator

    @Published var state: NotificationState = .loading
    @Published var notifications: [NotificationItemData] = []
    @Published var selectedFilter: NotificationFilter = .all

    public init(notificationRepository: NotificationRepository, argument: NotificationViewModel.Argument) {
        self.notificationRepository = notificationRepository
        self.navigator = argument.navigator
    }

    func didTapNotification(feedId: Int) {
        navigator.navigateToFeedDetail(feedId: feedId)
    }

    @MainActor
    func fetchNotifications() async {
        state = .loading
        do {
            let typeParam = apiTypeParam(for: selectedFilter)
            let items = try await notificationRepository.getNotifications(type: typeParam)
            if items.isEmpty {
                notifications = []
                state = .empty
            } else {
                notifications = items.map { toItemData($0) }
                state = .success
            }
        } catch {
            print("[NotificationViewModel] fetchNotifications error: \(error)")
            state = .error
        }
    }

    @MainActor
    func applyFilter(_ filter: NotificationFilter) async {
        selectedFilter = filter
        await fetchNotifications()
    }

    private func apiTypeParam(for filter: NotificationFilter) -> String? {
        switch filter {
        case .all: return nil
        case .myVotes: return "MY_FEED_CLOSED"
        case .participated: return "PARTICIPATED_FEED_CLOSED"
        }
    }

    private func toItemData(_ notification: AppNotification) -> NotificationItemData {
        NotificationItemData(
            id: String(notification.notificationId),
            imageURL: notification.viewUrl ?? "",
            status: "투표 종료",
            message: buildMessage(resultLabel: notification.resultLabel, resultPercent: notification.resultPercent),
            timeAgo: timeAgoText(from: notification.voteClosedAt),
            isRead: notification.isRead,
            feedId: notification.feedId
        )
    }

    private func buildMessage(resultLabel: ResultLabel, resultPercent: Int) -> String {
        switch resultLabel {
        case .yes:
            return "\(resultPercent)% '사! 가즈아!'"
        case .no:
            return "\(resultPercent)% '애매하긴 해!'"
        case .tie:
            return "무승부! 2차전 가보자고!"
        case .zero:
            return "아직 투표 결과가 없어요"
        }
    }

    private func timeAgoText(from components: DateComponents) -> String {
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            return ""
        }
        let now = Date()
        let diff = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)

        if let day = diff.day, day >= 7 {
            let weeks = day / 7
            return "\(weeks)주 전"
        } else if let day = diff.day, day >= 1 {
            return "\(day)일 전"
        } else if let hour = diff.hour, hour >= 1 {
            return "\(hour)시간 전"
        } else if let minute = diff.minute, minute >= 1 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }
}

public extension NotificationViewModel {
    struct Argument {
        let navigator: VoteNavigator

        public init(navigator: VoteNavigator) {
            self.navigator = navigator
        }
    }
}
