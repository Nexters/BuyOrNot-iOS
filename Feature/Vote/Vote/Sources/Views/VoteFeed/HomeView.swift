//
//  MainView.swift
//  DesignSystem
//
//  Created by 이조은 on 2/6/26.
//

import SwiftUI
import Domain
import DesignSystem

public struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    @State private var selectedTab: FeedTab = .voteFeed
    @State private var showBanner = true
    @State private var showNavigationBar: Bool = true

    public init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var shouldHideFilter: Bool {
        switch selectedTab {
        case .voteFeed:
            return viewModel.voteFeedState == .error
        case .myVotes:
            return viewModel.myVoteState == .error
        }
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if showNavigationBar {
                    NavigationBar(
                        onNotificationTap: { viewModel.didTapNotification() },
                        onProfileTap: { viewModel.didTapProfile() }
                    )
                }

                FeedSegmentedControl(selectedTab: $selectedTab)

                ScrollView {
                    VStack(spacing: 0) {
                        if !shouldHideFilter {
                            FeedFilterBar(selectedFilter: $viewModel.selectedFilter)
                        }
                        switch selectedTab {
                        case .voteFeed:
                            voteFeedContent
                        case .myVotes:
                            myVotesContent
                        }
                    }
                }
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            let isScrollingDown = value.translation.height < 0
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showNavigationBar = !isScrollingDown
                            }
                        }
                )
            }

            FloatingButton(
                state: .close,
                onVoteCreate: { viewModel.didTapCreateVote() }
            )

            VStack {
                Spacer()
                BNSnackBar(
                    item: viewModel.snackBar.currentItem,
                    state: $viewModel.snackBar.barState
                )
            }
        }
        .task {
            await viewModel.fetchFeeds()
        }
        .onReceive(NotificationCenter.default.publisher(for: .voteFeedDidCreate)) { _ in
            Task { await viewModel.fetchFeeds() }
        }
        .onChange(of: viewModel.selectedFilter) { _ in
            switch selectedTab {
            case .voteFeed:
                Task { await viewModel.fetchFeeds() }
            case .myVotes:
                Task { await viewModel.fetchMyFeeds() }
            }
        }
        .onChange(of: selectedTab) { tab in
            if tab == .myVotes {
                Task { await viewModel.fetchMyFeeds() }
            }
        }
    }

    @ViewBuilder
    private var voteFeedContent: some View {
        switch viewModel.voteFeedState {
        case .loading:
            ProgressView().padding(.top, 100)

        case .success:
            if viewModel.feeds.isEmpty {
                FeedEmptyView()
                    .padding(.top, 140)
            } else {
                if showBanner {
                    VStack {
                        Banner(
                            image: .feed_banner,
                            text: "고민되는 소비가 있나요?",
                            onClose: {
                                withAnimation { showBanner = false }
                            },
                            onAction: {
                                viewModel.didTapCreateVote()
                            }
                        )
                        .padding(.vertical, 12)
                        BNDivider(size: .s)
                    }
                    .padding(.horizontal, 20)
                }

                LazyVStack(spacing: 0) {
                    ForEach(viewModel.feeds, id: \.id) { feed in
                        VoteFeed(
                            data: feed,
                            onDelete: { Task { await viewModel.deleteFeed(feedId: feed.id) } },
                            onReport: { Task { await viewModel.reportFeed(feedId: feed.id) } },
                            onBlock: { Task { await viewModel.blockUser(userId: feed.userId, userName: feed.userName) } },
                            onVote: { optionId in
                                Task { await viewModel.vote(feedId: feed.id, optionId: optionId) }
                            }
                        )
                        .padding(.horizontal, 20)
                        .onAppear {
                            Task { await viewModel.fetchMoreIfNeeded(currentFeedId: feed.id) }
                        }
                    }
                }

                if viewModel.isLoadingMore {
                    ProgressView()
                        .padding(.vertical, 20)
                }
            }

        case .error:
            FeedErrorView {
                Task { await viewModel.fetchFeeds() }
            }
            .padding(.top, 140)
        }
    }

    @ViewBuilder
    private var myVotesContent: some View {
        switch viewModel.myVoteState {
        case .loading:
            ProgressView()
                .padding(.top, 100)

        case .success:
            LazyVStack(spacing: 0) {
                ForEach(viewModel.myFeeds, id: \.id) { feed in
                    VoteFeed(
                        data: feed,
                        onDelete: { Task { await viewModel.deleteFeed(feedId: feed.id) } },
                        onReport: { Task { await viewModel.reportFeed(feedId: feed.id) } },
                        onBlock: { Task { await viewModel.blockUser(userId: feed.userId, userName: feed.userName) } },
                        onVote: { optionId in
                            Task { await viewModel.vote(feedId: feed.id, optionId: optionId) }
                        }
                    )
                    .padding(.horizontal, 20)
                }
            }

        case .empty:
            FeedEmptyView()
                .padding(.top, 140)

        case .error:
            FeedErrorView {
                Task { await viewModel.fetchMyFeeds() }
            }
            .padding(.top, 140)
        }
    }
}

enum FeedTab: String, CaseIterable {
    case voteFeed = "투표 피드"
    case myVotes = "내 투표"
}

enum FeedFilter: String, CaseIterable {
    case all = "전체"
    case ongoing = "진행중 투표"
    case closed = "마감된 투표"
}


struct FeedSegmentedControl: View {
    @Binding var selectedTab: FeedTab
    @Namespace private var namespace

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 18) {
                ForEach(FeedTab.allCases, id: \.self) { tab in
                    TabItem(
                        title: tab.rawValue,
                        isSelected: selectedTab == tab,
                        namespace: namespace,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = tab
                            }
                        }
                    )
                    .fixedSize()
                }
                Spacer()
            }
            .padding(.horizontal, 20)

            Rectangle()
                .fill(BNColor(.type(.gray100)).color)
                .frame(height: 2)
        }
        .padding(.top, 12)
    }
}

private struct TabItem: View {
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 9) {
            BNText(title)
                .style(style: isSelected ? .t3b : .b4m, color: .gray1000)

            if isSelected {
                Rectangle()
                    .fill(BNColor(.type(.gray1000)).color)
                    .frame(height: 3)
                    .padding(.horizontal, -4)
                    .matchedGeometryEffect(id: "indicator", in: namespace)
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 3)
            }
        }
        .onTapGesture(perform: onTap)
    }
}

struct FeedFilterBar: View {
    @Binding var selectedFilter: FeedFilter

    var body: some View {
        HStack(spacing: 8) {
            ForEach(FeedFilter.allCases, id: \.self) { filter in
                BNChip(
                    title: filter.rawValue,
                    state: selectedFilter == filter ? .selected : .unselected,
                    onTap: { selectedFilter = filter }
                )
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

private struct PreviewFeedRepository: FeedRepository {
    func getVoteFeeds(cursor: Int?, size: Int, feedStatus: String?) async throws -> Domain.VotePage {
        VotePage(votes: [], nextCursor: nil, hasNext: false)
    }
    func getMyVoteFeeds(cursor: Int?, size: Int, feedStatus: String?) async throws -> Domain.VotePage {
        VotePage(votes: [], nextCursor: nil, hasNext: false)
    }
    func postVoteFeed(info: Domain.VoteCreateInfo) async throws -> Int { 0 }
    func voteFeed(feedId: Int, choice: Domain.VoteChoice) async throws -> Domain.VoteResult {
        VoteResult(feedId: feedId, choice: choice, yesCount: 0, noCount: 0, totalCount: 0)
    }
    func reportVoteFeed(feedId: Int) async throws {}
    func deleteVoteFeed(feedId: Int) async throws {}
    func getFeedDetail(feedId: Int) async throws -> Vote {
        Vote(
            feedId: feedId,
            content: "",
            price: 0,
            category: .etc,
            yesCount: 0,
            noCount: 0,
            voteStatus: .open,
            s3ObjectKey: "",
            viewUrl: "",
            imageWidth: 0,
            imageHeight: 0,
            author: FeedAuthor(id: 0, nickname: "", profileImage: ""),
            createdAt: DateComponents(),
            hasVoted: false,
            myVoteChoice: nil
        )
    }
}

private struct PreviewUserRepository: UserRepository {
    func getMe() async throws -> User {
        User(id: 1, nickname: "preview", profileImage: "", socialAccount: "KAKAO", email: "")
    }
    func getCachedUser() -> User? {
        User(id: 1, nickname: "preview", profileImage: "", socialAccount: "KAKAO", email: "")
    }
    func updateFCMToken(_ token: String) async throws {}
    func deleteAccount() async throws {}
    func blockUser(userId: Int) async throws {}
    func getBlockedUsers() async throws -> [BlockedUser] { [] }
    func unblockUser(userId: Int) async throws {}
}

private struct MockVoteNavigator: VoteNavigator {
    func navigateToNotification() {}
    func navigateToMyPage() {}
    func presentCreateVote() {}
    func navigateToFeedDetail(feedId: Int) {}
}

#Preview {
    let _ = BNFont.loadFonts()
    HomeView(
        viewModel: HomeViewModel(
            feedRepository: PreviewFeedRepository(),
            userRepository: PreviewUserRepository(),
            argument: .init(
                navigator: MockVoteNavigator()
            )
        )
    )
}
