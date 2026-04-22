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
    @State private var showCategoryFilter: Bool = true
    @State private var showFilterSheet = false

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
                        isGuest: !viewModel.isAuthenticated,
                        onNotificationTap: { viewModel.didTapNotification() },
                        onProfileTap: { viewModel.didTapProfile() },
                        onLoginTap: { viewModel.didTapLogin() }
                    )
                }

                FeedSegmentedControl(
                    selectedTab: $selectedTab,
                    tabs: viewModel.isAuthenticated ? FeedTab.allCases : [.voteFeed]
                )

                if !shouldHideFilter && showCategoryFilter {
                    FeedCategoryFilterBar(
                        selectedCategories: $viewModel.selectedCategories,
                        showFilterSheet: $showFilterSheet
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                ScrollView {
                    VStack(spacing: 0) {
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
                                showCategoryFilter = !isScrollingDown
                            }
                        }
                )
            }

            FloatingButton(
                state: .close,
                onVoteCreate: { viewModel.didTapCreateVote() }
            )

            if showFilterSheet {
                FeedFilterSheet(
                    selectedFilter: $viewModel.selectedFilter,
                    isPresented: $showFilterSheet
                )
                .transition(.opacity)
                .zIndex(10)
            }

            VStack {
                Spacer()
                BNSnackBar(
                    item: viewModel.snackBar.currentItem,
                    state: $viewModel.snackBar.barState
                )
                .padding(.bottom, 90)
            }
        }
        .task {
            await viewModel.fetchFeeds()
        }
        .onReceive(NotificationCenter.default.publisher(for: .voteFeedDidCreate)) { _ in
            Task { await viewModel.fetchFeeds() }
        }
        .onChange(of: viewModel.selectedFilter) { _, _ in
            switch selectedTab {
            case .voteFeed:
                Task { await viewModel.fetchFeeds() }
            case .myVotes:
                Task { await viewModel.fetchMyFeeds() }
            }
        }
        .onChange(of: selectedTab) { _, newValue in
            if newValue == .myVotes {
                Task { await viewModel.fetchMyFeeds() }
            }
        }
        .onChange(of: viewModel.selectedCategories) { _, _ in
            switch selectedTab {
            case .voteFeed:
                Task { await viewModel.fetchFeeds() }
            case .myVotes:
                Task { await viewModel.fetchMyFeeds() }
            }
        }
    }

    private var voteFeedTooltipId: String? {
        viewModel.feeds.first(where: { $0.link != nil })?.id
    }

    private var myFeedTooltipId: String? {
        viewModel.myFeeds.first(where: { $0.link != nil })?.id
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
                            showLinkTooltip: feed.id == voteFeedTooltipId,
                            onDelete: { Task { await viewModel.deleteFeed(feedId: feed.id) } },
                            onReport: { Task { await viewModel.reportFeed(feedId: feed.id) } },
                            onBlock: { Task { await viewModel.blockUser(userId: feed.userId, userName: feed.userName) } },
                            onVote: { optionId in
                                Task { await viewModel.vote(feedId: feed.id, optionId: optionId) }
                            }
                        )
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
                        showLinkTooltip: feed.id == myFeedTooltipId,
                        onDelete: { Task { await viewModel.deleteFeed(feedId: feed.id) } },
                        onReport: { Task { await viewModel.reportFeed(feedId: feed.id) } },
                        onBlock: { Task { await viewModel.blockUser(userId: feed.userId, userName: feed.userName) } },
                        onVote: { optionId in
                            Task { await viewModel.vote(feedId: feed.id, optionId: optionId) }
                        }
                    )
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
    let tabs: [FeedTab]
    @Namespace private var namespace

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 18) {
                ForEach(tabs, id: \.self) { tab in
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
                .fill(ColorPalette.gray100)
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
                .style(
                    style: isSelected ? .t3b : .b4m,
                    color: ColorPalette.gray1000
                )

            if isSelected {
                Rectangle()
                    .fill(ColorPalette.gray1000)
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

struct FeedCategoryFilterBar: View {
    @Binding var selectedCategories: Set<FeedCategory>
    @Binding var showFilterSheet: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                FeedFilterIconChip(onTap: { showFilterSheet = true })
                FeedFilterChip(
                    title: "전체",
                    isSelected: selectedCategories.isEmpty,
                    onTap: { selectedCategories = [] }
                )
                ForEach(FeedCategory.allCases, id: \.rawValue) { category in
                    FeedFilterChip(
                        title: category.displayName,
                        isSelected: selectedCategories.contains(category),
                        onTap: {
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
        }
        .frame(height: 38)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}

private struct FeedFilterSheet: View {
    @Binding var selectedFilter: FeedFilter
    @Binding var isPresented: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) { isPresented = false }
                }

            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(ColorPalette.gray400)
                        .frame(width: 40, height: 4)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    BNText("피드 정렬")
                        .style(style: .s1sb, color: ColorPalette.gray950)
                        .padding(.leading, 24)
                        .padding(.top, 30)
                }
                .frame(height: 62)

                VStack(spacing: 18) {
                    ForEach(FeedFilter.allCases, id: \.self) { filter in
                        FilterOptionRow(
                            title: filter.rawValue,
                            isSelected: selectedFilter == filter,
                            onTap: {
                                selectedFilter = filter
                                withAnimation(.easeInOut(duration: 0.2)) { isPresented = false }
                            }
                        )
                    }
                    Color.clear.frame(height: 30)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity)
            .background(ColorPalette.gray0)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .padding(.horizontal, 14)
            .padding(.bottom, 50)
        }
        .ignoresSafeArea()
    }
}

private struct FilterOptionRow: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                BNText(title)
                    .style(
                        style: isSelected ? .s3sb : .b3m,
                        color: isSelected ? ColorPalette.gray950 : ColorPalette.gray700
                    )
                Spacer()
                if isSelected {
                    BNImage(.check)
                        .style(color: ColorPalette.gray950, size: 20)
                }
            }
            .frame(height: 30)
        }
        .buttonStyle(.plain)
    }
}

private struct FeedFilterIconChip: View {
    let onTap: () -> Void

    var body: some View {
        Button { onTap() } label: {
            BNImage(.list)
                .style(color: ColorPalette.gray800, size: 20)
                .frame(width: 44, height: 36)
                .background(ColorPalette.gray0)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(ColorPalette.gray300, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}

private struct FeedFilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            BNText(title)
                .style(style: .b5m, color: ColorPalette.gray950)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(height: 36)
                .background(isSelected ? ColorPalette.gray200 : ColorPalette.gray0)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(ColorPalette.gray300, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}

private struct PreviewFeedRepository: FeedRepository {
    func getVoteFeeds(cursor: Int?, size: Int, feedStatus: String?, category: String?) async throws -> Domain.VotePage {
        VotePage(votes: [], nextCursor: nil, hasNext: false)
    }
    func getMyVoteFeeds(cursor: Int?, size: Int, feedStatus: String?, category: String?) async throws -> Domain.VotePage {
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
            images: [],
            author: FeedAuthor(id: 0, nickname: "", profileImage: ""),
            createdAt: DateComponents(),
            hasVoted: false,
            myVoteChoice: nil,
            link: nil,
            title: nil
        )
    }
}

private struct PreviewUserRepository: UserRepository {
    func cacheUser(_ user: User) {}
    func clearCachedUser() {}

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

private struct PreviewReportFeedRepository: ReportFeedRepository {
    func saveReportFeed(_ feed: ReportFeed) {}
    func getReportFeed() -> ReportFeed? { nil }
    func removeReportFeed() {}
}

private struct MockVoteNavigator: VoteNavigator {
    func navigateToNotification() {}
    func navigateToMyPage() {}
    func navigateToLogin() {}
    func presentCreateVote() {}
    func navigateToFeedDetail(feedId: Int) {}
}

#Preview {
    let _ = BNFont.loadFonts()
    HomeView(
        viewModel: HomeViewModel(
            feedRepository: PreviewFeedRepository(),
            userRepository: PreviewUserRepository(),
            reportFeedRepository: PreviewReportFeedRepository(),
            argument: .init(
                navigator: MockVoteNavigator()
            )
        )
    )
}
