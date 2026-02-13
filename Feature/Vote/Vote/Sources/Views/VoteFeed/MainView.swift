//
//  MainView.swift
//  DesignSystem
//
//  Created by 이조은 on 2/6/26.
//

import SwiftUI
import DesignSystem

struct MainView: View {
    // TODO: navigationPath 연결 시 수정
    @State private var navigationPath = NavigationPath()

    @State private var selectedTab: FeedTab = .voteFeed
    @State private var selectedFilter: FeedFilter = .all
    @State private var showBanner = true
    @State private var voteFeedState: VoteFeedState = .success
    @State private var myVoteState: MyVoteState = .empty

    private let sampleFeeds: [VoteFeedData] = [
        VoteFeedData(
            id: "1",
            userName: "조은",
            userProfileImageURL: "https://www.studiopeople.kr/common/img/default_profile.png",
            category: "전자기기",
            timeAgo: "6시간 전",
            content: "맥북 프로 M4 살까 고민중인데 어떻게 생각하세요?",
            productImageURL: "https://www.locknlock.com/kor/image/story/lounge/ex/vr/tvahbryl/html/56994767otqf.jpg",
            price: "₩ 2,490,000",
            voteOptions: [
                .init(id: 0, text: "사! 가즈아!", voteCount: 45, imageURL: "https://example.com/profile.jpg"),
                .init(id: 1, text: "애매하긴 해..", voteCount: 23, imageURL: "https://example.com/profile.jpg")
            ]
        ),
        VoteFeedData(
            id: "2",
            userName: "민수",
            userProfileImageURL: "https://www.studiopeople.kr/common/img/default_profile.png",
            category: "패션",
            timeAgo: "12시간 전",
            content: "겨울 패딩 이거 어때요? 가격대가 좀 있는데...",
            productImageURL: "https://www.locknlock.com/kor/image/story/lounge/ex/vr/tvahbryl/html/56994767otqf.jpg",
            price: "₩ 389,000",
            voteOptions: [
                .init(id: 0, text: "사! 가즈아!", voteCount: 67, imageURL: "https://example.com/profile.jpg"),
                .init(id: 1, text: "애매하긴 해..", voteCount: 12, imageURL: "https://example.com/profile.jpg")
            ]
        ),
        VoteFeedData(
            id: "3",
            userName: "지영",
            userProfileImageURL: "https://www.studiopeople.kr/common/img/default_profile.png",
            category: "뷰티",
            timeAgo: "1일 전",
            content: "이 립스틱 색상 예쁘지 않나요?",
            productImageURL: "https://www.locknlock.com/kor/image/story/lounge/ex/vr/tvahbryl/html/56994767otqf.jpg",
            price: "₩ 42,000",
            voteOptions: [
                .init(id: 0, text: "사! 가즈아!", voteCount: 89, imageURL: "https://example.com/profile.jpg"),
                .init(id: 1, text: "애매하긴 해..", voteCount: 34, imageURL: "https://example.com/profile.jpg")
            ]
        )
    ]

    private var shouldHideFilter: Bool {
        switch selectedTab {
        case .voteFeed:
            return voteFeedState == .error
        case .myVotes:
            return myVoteState == .error || myVoteState == .empty
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                VStack(spacing: 0) {
                    NavigationBar(
                        onNotificationTap: {
                            print("Notification tapped")
                        },
                        onProfileTap: {
                            print("Profile tapped")
                        }
                    )

                    FeedSegmentedControl(selectedTab: $selectedTab)

                    if !shouldHideFilter {
                        FeedFilterBar(selectedFilter: $selectedFilter)
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
                }

                // TODO: FloatingButton init 상의해보고 수정
                FloatingButton(state: .open)
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "VoteRegistration":
                    Text("투표 등록 화면")
                default:
                    EmptyView()
                }
            }
        }
    }

    @ViewBuilder
    private var voteFeedContent: some View {
        switch voteFeedState {
        case .loading:
            ProgressView().padding(.top, 100)

        case .success:
            if showBanner {
                Banner(
                    image: .feed_banner,
                    text: "고민되는 소비가 있나요?",
                    onClose: {
                        withAnimation { showBanner = false }
                    },
                    onAction: {
                        navigationPath.append("VoteRegistration")
                    }
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }

            LazyVStack(spacing: 0) {
                ForEach(sampleFeeds, id: \.id) { feed in
                    VoteFeed(
                        data: feed,
                        onProductTap: { print("Product tapped: \(feed.id)") },
                        onVote: { optionId in print("Voted \(optionId) on feed: \(feed.id)") }
                    )
                    .padding(.horizontal, 20)
                }
            }

        case .error:
            FeedErrorView {
                voteFeedState = .loading
            }
            .padding(.top, 140)
        }
    }

    @ViewBuilder
    private var myVotesContent: some View {
        switch myVoteState {
        case .loading:
            ProgressView()
                .padding(.top, 100)

        case .success:
            LazyVStack(spacing: 0) {
                ForEach(sampleFeeds, id: \.id) { feed in
                    VoteFeed(
                        data: feed,
                        onProductTap: { print("Product tapped: \(feed.id)") },
                        onVote: { optionId in print("Voted \(optionId) on feed: \(feed.id)") }
                    )
                    .padding(.horizontal, 20)
                }
            }

        case .empty:
            FeedEmptyView()
                .padding(.top, 140)

        case .error:
            FeedErrorView {
                myVoteState = .loading
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
            Text(title)
                .font(BNFont.font(isSelected ? .t3b : .b4m))
                .foregroundColor(BNColor(.type(.gray1000)).color)

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
        .padding(20)
    }
}

#Preview {
    let _ = BNFont.loadFonts()
    MainView()
}
