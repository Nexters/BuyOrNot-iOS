//
//  FeedDetailViewModel.swift
//  Vote
//
//  Created by 이조은 on 2/25/26.
//

import SwiftUI
import Domain
import DesignSystem

public final class FeedDetailViewModel: ObservableObject {
    private let feedRepository: FeedRepository
    private let userRepository: UserRepository
    private let currentUserId: Int?

    @Published var state: VoteFeedState = .loading
    @Published var feed: VoteFeedData?
    @Published var snackBar = BNSnackBarManager()

    public init(feedRepository: FeedRepository, userRepository: UserRepository) {
        self.feedRepository = feedRepository
        self.userRepository = userRepository
        self.currentUserId = userRepository.getCachedUser()?.id
    }

    @MainActor
    func fetchFeed(feedId: Int) async {
        state = .loading
        do {
            let vote = try await feedRepository.getFeedDetail(feedId: feedId)
            feed = toVoteFeedData(vote)
            state = .success
        } catch {
            print("[FeedDetailViewModel] fetchFeed error: \(error)")
            state = .error
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
            print("[FeedDetailViewModel] vote error: \(error)")
        }
    }

    @MainActor
    func deleteFeed(feedId: String) async {
        guard let id = Int(feedId) else { return }
        do {
            try await feedRepository.deleteVoteFeed(feedId: id)
            feed = nil
        } catch {
            print("[FeedDetailViewModel] deleteFeed error: \(error)")
        }
    }

    @MainActor
    func reportFeed(feedId: String) async {
        guard let id = Int(feedId) else { return }
        do {
            try await feedRepository.reportVoteFeed(feedId: id)
            feed = nil
        } catch {
            print("[FeedDetailViewModel] reportFeed error: \(error)")
        }
    }

    @MainActor
    func blockUser(userId: Int, userName: String) async {
        do {
            try await userRepository.blockUser(userId: userId)
            feed = nil
            let item = BNSnackBarItem(
                text: "\(userName)님이 차단되었어요."
            )
            snackBar.addItem(item)
        } catch {
            print("[FeedDetailViewModel] blockUser error: \(error)")
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
        guard let item = feed else { return }
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
        feed = VoteFeedData(
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

    private func toVoteFeedData(_ vote: Vote) -> VoteFeedData {
        let selectedVoteId: Int? = {
            switch vote.myVoteChoice {
            case .yes: return 0
            case .no: return 1
            case .none: return nil
            }
        }()
        let isMyFeed = currentUserId != nil && vote.author.id == currentUserId

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
