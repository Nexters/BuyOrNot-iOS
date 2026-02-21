//
//  HomeViewModel.swift
//  Vote
//
//  Created by 이조은 on 2/21/26.
//

import SwiftUI
import Domain
import DesignSystem

public final class HomeViewModel: ObservableObject {
    private let repository: FeedRepository
    private let pageSize = 10

    @Published var voteFeedState: VoteFeedState = .loading
    @Published var feeds: [VoteFeedData] = []
    @Published var selectedFilter: FeedFilter = .all
    @Published var isLoadingMore: Bool = false

    @Published var myVoteState: MyVoteState = .loading
    @Published var myFeeds: [VoteFeedData] = []

    private var cursor: Int?
    private var hasMorePages: Bool = true

    public init(repository: FeedRepository) {
        self.repository = repository
    }

    @MainActor
    func fetchFeeds() async {
        cursor = nil
        hasMorePages = true
        voteFeedState = .loading
        do {
            let page = try await repository.getVoteFeeds(
                cursor: nil,
                size: pageSize,
                feedStatus: feedStatusParam(for: selectedFilter)
            )
            feeds = page.votes.map { toVoteFeedData($0) }
            cursor = page.nextCursor
            hasMorePages = page.hasNext
            voteFeedState = .success
        } catch {
            print("[HomeViewModel] fetchFeeds error: \(error)")
            voteFeedState = .error
        }
    }

    @MainActor
    func fetchMoreIfNeeded(currentFeedId: String) async {
        guard let lastFeed = feeds.last,
              currentFeedId == lastFeed.id,
              hasMorePages,
              !isLoadingMore else { return }

        isLoadingMore = true
        do {
            let page = try await repository.getVoteFeeds(
                cursor: cursor,
                size: pageSize,
                feedStatus: feedStatusParam(for: selectedFilter)
            )
            feeds.append(contentsOf: page.votes.map { toVoteFeedData($0) })
            cursor = page.nextCursor
            hasMorePages = page.hasNext
        } catch {
            // TODO: 추가 로드 실패 스낵바 추가
        }
        isLoadingMore = false
    }

    @MainActor
    func applyFilter(_ filter: FeedFilter) async {
        selectedFilter = filter
        await fetchFeeds()
    }

    @MainActor
    func fetchMyFeeds() async {
        myVoteState = .loading
        do {
            let votes = try await repository.getMyVoteFeeds()
            if votes.isEmpty {
                myVoteState = .empty
            } else {
                myFeeds = votes.map { toVoteFeedData($0) }
                myVoteState = .success
            }
        } catch {
            print("[HomeViewModel] fetchMyFeeds error: \(error)")
            myVoteState = .error
        }
    }

    private func feedStatusParam(for filter: FeedFilter) -> String? {
        switch filter {
        case .all: return nil
        case .ongoing: return "OPEN"
        case .closed: return "CLOSED"
        }
    }

    private func toVoteFeedData(_ vote: Vote) -> VoteFeedData {
        VoteFeedData(
            id: String(vote.feedId),
            userName: vote.author.nickname,
            userProfileImageURL: vote.author.profileImage,
            category: categoryDisplayName(vote.category),
            timeAgo: timeAgoText(from: vote.createdAt),
            content: vote.content,
            productImageURL: vote.viewUrl,
            price: formatPrice(vote.price),
            voteOptions: [
                .init(id: 0, text: "사! 가즈아!", voteCount: vote.yesCount),
                .init(id: 1, text: "애매하긴 해..", voteCount: vote.noCount)
            ],
            isPeriodDone: vote.voteStatus == .closed
        )
    }

    private func categoryDisplayName(_ category: FeedCategory) -> String {
        switch category {
        case .luxury: return "명품"
        case .fashion: return "패션"
        case .beauty: return "뷰티"
        case .food: return "음식"
        case .electronics: return "전자기기"
        case .travel: return "여행"
        case .health: return "건강"
        case .book: return "도서"
        case .etc: return "기타"
        }
    }

    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: price)) ?? "\(price)"
        return "₩ \(formatted)"
    }

    private func timeAgoText(from components: DateComponents) -> String {
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            return ""
        }
        let now = Date()
        let diff = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)

        if let day = diff.day, day >= 1 {
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
