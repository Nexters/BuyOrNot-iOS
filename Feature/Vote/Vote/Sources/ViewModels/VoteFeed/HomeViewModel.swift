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
    private let feedRepository: FeedRepository
    private let userRepository: UserRepository
    private let reportFeedRepository: ReportFeedRepository
    private let navigator: VoteNavigator
    private let currentUserId: Int?
    private let pageSize = 10

    @Published var voteFeedState: VoteFeedState = .loading
    @Published var feeds: [VoteFeedData] = []
    @Published var selectedFilter: FeedFilter = .all
    @Published var isLoadingMore: Bool = false

    @Published var isGuest: Bool = false
    @Published var myVoteState: MyVoteState = .loading
    @Published var myFeeds: [VoteFeedData] = []
    @Published var snackBar = BNSnackBarManager()

    private var cursor: Int?
    private var hasMorePages: Bool = true
    private var removedFeedIds: Set<String> = []
    private var reportedFeedIds: Set<String> = []

    public init(
        feedRepository: FeedRepository,
        userRepository: UserRepository,
        reportFeedRepository: ReportFeedRepository,
        argument: HomeViewModel.Argument
    ) {
        self.feedRepository = feedRepository
        self.userRepository = userRepository
        self.reportFeedRepository = reportFeedRepository
        self.navigator = argument.navigator
        self.currentUserId = userRepository.getCachedUser()?.id
        self.isGuest = self.currentUserId == nil
        self.reportedFeedIds = reportFeedRepository.getReportFeed()?.ids ?? []
        self.removedFeedIds = reportedFeedIds
        #if DEBUG
        print("🔍 [HomeViewModel] currentUserId: \(String(describing: self.currentUserId))")
        #endif
    }

    func didTapNotification() {
        navigator.navigateToNotification()
    }

    func didTapProfile() {
        navigator.navigateToMyPage()
    }

    func didTapLogin() {
        navigator.navigateToLogin()
    }

    func didTapCreateVote() {
        navigator.presentCreateVote()
    }

    @MainActor
    func fetchFeeds() async {
        cursor = nil
        hasMorePages = true
        voteFeedState = .loading
        do {
            let page = try await feedRepository.getVoteFeeds(
                cursor: nil,
                size: pageSize,
                feedStatus: feedStatusParam(for: selectedFilter)
            )
            feeds = page.votes
                .filter { removedFeedIds.contains(String($0.feedId)) == false }
                .map { toVoteFeedData($0) }
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
            let page = try await feedRepository.getVoteFeeds(
                cursor: cursor,
                size: pageSize,
                feedStatus: feedStatusParam(for: selectedFilter)
            )
            appendUniqueFeeds(
                page.votes
                    .filter { removedFeedIds.contains(String($0.feedId)) == false }
                    .map { toVoteFeedData($0) }
            )
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
    func deleteFeed(feedId: String) async {
        guard let id = Int(feedId) else { return }
        do {
            try await feedRepository.deleteVoteFeed(feedId: id)
            removedFeedIds.insert(feedId)
            feeds.removeAll { $0.id == feedId }
            myFeeds.removeAll { $0.id == feedId }
            if myFeeds.isEmpty {
                myVoteState = .empty
            }
            await backfillFeedIfNeeded()
        } catch {
            print("[HomeViewModel] deleteFeed error: \(error)")
        }
    }

    @MainActor
    func reportFeed(feedId: String) async {
        guard let id = Int(feedId) else { return }
        do {
            try await feedRepository.reportVoteFeed(feedId: id)
            removedFeedIds.insert(feedId)
            reportedFeedIds.insert(feedId)
            reportFeedRepository.saveReportFeed(
                ReportFeed(ids: reportedFeedIds)
            )
            feeds.removeAll { $0.id == feedId }
            myFeeds.removeAll { $0.id == feedId }
            if myFeeds.isEmpty {
                myVoteState = .empty
            }
            await backfillFeedIfNeeded()
        } catch {
            print("[HomeViewModel] reportFeed error: \(error)")
        }
    }

    @MainActor
    func blockUser(userId: Int, userName: String) async {
        do {
            try await userRepository.blockUser(userId: userId)
            let item = BNSnackBarItem(
                text: "\(userName)님이 차단되었어요."
            )
            snackBar.addItem(item)
            await fetchFeeds()
            await fetchMyFeeds()
        } catch {
            print("[HomeViewModel] blockUser error: \(error)")
        }
    }

    @MainActor
    func vote(feedId: String, optionId: Int) async {
        guard let id = Int(feedId),
              let choice = voteChoice(for: optionId) else { return }
        do {
            let result = try await feedRepository.voteFeed(feedId: id, choice: choice)
            applyVoteResult(result, selectedOptionId: optionId)
        } catch {
            print("[HomeViewModel] vote error: \(error)")
        }
    }

    @MainActor
    func fetchMyFeeds() async {
        myVoteState = .loading
        do {
            let page = try await feedRepository.getMyVoteFeeds(
                cursor: nil,
                size: pageSize,
                feedStatus: feedStatusParam(for: selectedFilter)
            )
            let filteredVotes = page.votes.filter {
                removedFeedIds.contains(String($0.feedId)) == false
            }
            if filteredVotes.isEmpty {
                myFeeds = []
                myVoteState = .empty
            } else {
                myFeeds = filteredVotes.map { toVoteFeedData($0, isMine: true) }
                myVoteState = .success
            }
        } catch {
            print("[HomeViewModel] fetchMyFeeds error: \(error)")
            myVoteState = .error
        }
    }

    @MainActor
    private func backfillFeedIfNeeded() async {
        guard hasMorePages, isLoadingMore == false else {
            return
        }
        isLoadingMore = true
        defer { isLoadingMore = false }

        while hasMorePages {
            do {
                let page = try await feedRepository.getVoteFeeds(
                    cursor: cursor,
                    size: pageSize,
                    feedStatus: feedStatusParam(for: selectedFilter)
                )
                cursor = page.nextCursor
                hasMorePages = page.hasNext

                let newFeeds = page.votes
                    .filter { removedFeedIds.contains(String($0.feedId)) == false }
                    .map { toVoteFeedData($0) }
                appendUniqueFeeds(newFeeds)

                if newFeeds.isEmpty == false {
                    break
                }
            } catch {
                break
            }
        }
    }

    private func appendUniqueFeeds(_ items: [VoteFeedData]) {
        guard items.isEmpty == false else { return }
        var existingFeedIds = Set(feeds.map(\.id))
        for item in items where existingFeedIds.contains(item.id) == false {
            feeds.append(item)
            existingFeedIds.insert(item.id)
        }
    }

    private func feedStatusParam(for filter: FeedFilter) -> String? {
        switch filter {
        case .all: return nil
        case .ongoing: return "OPEN"
        case .closed: return "CLOSED"
        }
    }

    private func voteChoice(for optionId: Int) -> VoteChoice? {
        switch optionId {
        case 0: return .yes
        case 1: return .no
        default: return nil
        }
    }

    private func applyVoteResult(_ result: VoteResult, selectedOptionId: Int) {
        let feedId = String(result.feedId)

        func update(_ item: VoteFeedData) -> VoteFeedData {
            let updatedOptions: [VoteGroup.VoteOption] = [
                .init(
                    id: 0,
                    text: "사! 가즈아!",
                    voteCount: result.yesCount,
                    imageURL: selectedOptionId == 0 ? item.userProfileImageURL : nil
                ),
                .init(
                    id: 1,
                    text: "애매하긴 해..",
                    voteCount: result.noCount,
                    imageURL: selectedOptionId == 1 ? item.userProfileImageURL : nil
                )
            ]
            return VoteFeedData(
                id: item.id,
                userId: item.userId,
                userName: item.userName,
                userProfileImageURL: item.userProfileImageURL,
                category: item.category,
                timeAgo: item.timeAgo,
                content: item.content,
                productImageURL: item.productImageURL,
                price: item.price,
                voteOptions: updatedOptions,
                selectedVoteId: selectedOptionId,
                isPeriodDone: item.isPeriodDone,
                isMine: item.isMine,
                isVotingLocked: item.isVotingLocked
            )
        }

        if let index = feeds.firstIndex(where: { $0.id == feedId }) {
            feeds[index] = update(feeds[index])
        }
        if let index = myFeeds.firstIndex(where: { $0.id == feedId }) {
            myFeeds[index] = update(myFeeds[index])
        }
    }

    private func toVoteFeedData(_ vote: Vote, isMine: Bool = false) -> VoteFeedData {
        let selectedVoteId: Int? = {
            switch vote.myVoteChoice {
            case .yes: return 0
            case .no: return 1
            case .none: return nil
            }
        }()
        let isMyFeed = isMine || (currentUserId != nil && vote.author.id == currentUserId)

        return VoteFeedData(
            id: String(vote.feedId),
            userId: vote.author.id,
            userName: vote.author.nickname,
            userProfileImageURL: vote.author.profileImage,
            category: categoryDisplayName(vote.category),
            timeAgo: timeAgoText(from: vote.createdAt),
            content: vote.content,
            productImageURL: vote.viewUrl,
            price: formatPrice(vote.price),
            voteOptions: voteOptions(
                yesCount: vote.yesCount,
                noCount: vote.noCount,
                selectedOptionId: selectedVoteId,
                userProfileImageURL: vote.author.profileImage
            ),
            selectedVoteId: selectedVoteId,
            isPeriodDone: vote.voteStatus == .closed,
            isMine: isMyFeed,
            isVotingLocked: isMyFeed
        )
    }

    private func voteOptions(
        yesCount: Int,
        noCount: Int,
        selectedOptionId: Int?,
        userProfileImageURL: String
    ) -> [VoteGroup.VoteOption] {
        [
            .init(
                id: 0,
                text: "사! 가즈아!",
                voteCount: yesCount,
                imageURL: selectedOptionId == 0 ? userProfileImageURL : nil
            ),
            .init(
                id: 1,
                text: "애매하긴 해..",
                voteCount: noCount,
                imageURL: selectedOptionId == 1 ? userProfileImageURL : nil
            )
        ]
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

public extension HomeViewModel {
    struct Argument {
        let navigator: VoteNavigator
        
        public init(navigator: VoteNavigator) {
            self.navigator = navigator
        }
    }
}
