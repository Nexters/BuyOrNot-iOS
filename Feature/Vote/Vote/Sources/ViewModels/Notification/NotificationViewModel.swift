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
    private let onAppearHandler: () -> Void

    private static var cachedNotifications: [NotificationItemData] = []
    private static var cachedState: NotificationState = .loading
    private static var cachedFilter: NotificationFilter = .all

    @Published var state: NotificationState = .loading
    @Published var notifications: [NotificationItemData] = []
    @Published var selectedFilter: NotificationFilter = .all

    public init(notificationRepository: NotificationRepository, argument: NotificationViewModel.Argument) {
        self.notificationRepository = notificationRepository
        self.navigator = argument.navigator
        self.onAppearHandler = argument.onAppear
        self.notifications = Self.cachedNotifications
        self.state = Self.cachedState
        self.selectedFilter = Self.cachedFilter
    }

    func didTapNotification(feedId: Int) {
        navigator.navigateToFeedDetail(feedId: feedId)
    }

    func onAppear() {
        onAppearHandler()
    }

    @MainActor
    func fetchNotifications(force: Bool = false) async {
        let hasData = !notifications.isEmpty
        if !force, hasData {
            return
        }
        let previousState = state
        if !hasData {
            state = .loading
        }
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
            Self.cachedNotifications = notifications
            Self.cachedState = state
            Self.cachedFilter = selectedFilter
        } catch is CancellationError {
            state = hasData ? previousState : .error
        } catch {
            print("[NotificationViewModel] fetchNotifications error: \(error)")
            state = .error
        }
    }

    @MainActor
    func applyFilter(_ filter: NotificationFilter) async {
        selectedFilter = filter
        await fetchNotifications(force: true)
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
            message: notification.feedTitle,
            timeAgo: timeAgoText(from: notification.voteClosedAt),
            isRead: notification.isRead,
            feedId: notification.feedId
        )
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
        let onAppear: () -> Void

        public init(navigator: VoteNavigator, onAppear: @escaping () -> Void = {}) {
            self.navigator = navigator
            self.onAppear = onAppear
        }
    }
}
