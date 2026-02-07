//
//  MainView.swift
//  DesignSystem
//
//  Created by 이조은 on 2/6/26.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: FeedTab = .voteFeed
    @State private var selectedFilter: FeedFilter = .all
    @State private var showBanner = true
    @State private var navigationPath = NavigationPath()

    // 샘플 데이터 (나중에 ViewModel에서 가져올 예정)
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

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                FeedNavigationBar(
                    onNotificationTap: {
                        print("Notification tapped")
                    },
                    onProfileTap: {
                        print("Profile tapped")
                    }
                )

                FeedSegmentedControl(selectedTab: $selectedTab)

                FeedFilterBar(selectedFilter: $selectedFilter)

                ScrollView {
                    VStack(spacing: 0) {
                        // 배너
                        if showBanner {
                            Banner(
                                image: .feed_banner,
                                text: "고민되는 소비가 있나요?",
                                onClose: {
                                    withAnimation {
                                        showBanner = false
                                    }
                                },
                                onAction: {
                                    // 투표 등록 화면으로 이동
                                    navigationPath.append("VoteRegistration")
                                }
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 12)
                        }

                        // 피드 리스트
                        LazyVStack(spacing: 0) {
                            ForEach(sampleFeeds, id: \.id) { feed in
                                VoteFeed(
                                    data: feed,
                                    onProductTap: {
                                        print("Product tapped: \(feed.id)")
                                        // 상품 상세로 이동
                                    },
                                    onVote: { optionId in
                                        print("Voted \(optionId) on feed: \(feed.id)")
                                        // 투표 API 호출
                                    }
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .refreshable {
                    /// TODO: 페이지네이션 구현
                }
            }
        }
    }
}

// MARK: - Tab & Filter Enums
enum FeedTab: String, CaseIterable {
    case voteFeed = "투표 피드"
    case myVotes = "내 투표"
}

enum FeedFilter: String, CaseIterable {
    case all = "전체"
    case ongoing = "진행중 투표"
    case closed = "마감된 투표"
}

// MARK: - Navigation Bar
struct FeedNavigationBar: View {
    let onNotificationTap: () -> Void
    let onProfileTap: () -> Void

    var body: some View {
        HStack {
            // 로고 이미지로 변경
            BNImage(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 82)
                .padding(.leading, 2)

            Spacer()

            HStack(spacing: 24) {
                Button {
                    onNotificationTap()
                } label: {
                    BNImage(.notification_fill)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(BNColor(.type(.gray500)).color)
                }

                Button {
                    onProfileTap()
                } label: {
                    BNImage(.my)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(BNColor(.type(.gray500)).color)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}

// MARK: - Segmented Control
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
                    .fixedSize()  // 텍스트 크기만큼만 차지
                }

                Spacer()  // 나머지 공간은 오른쪽 공백
            }
            .padding(.horizontal, 20)

            // Divider
            Rectangle()
                .fill(BNColor(.type(.gray100)).color)
                .frame(height: 2)
        }
        .padding(.top, 12)
    }
}

// MARK: - Tab Item
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

            // Underline - 텍스트 width + 좌우 4씩
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
// MARK: - Preference Key
private struct TabWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Filter Bar
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

// MARK: - Content View
struct FeedContentView: View {
    let tab: FeedTab
    let filter: FeedFilter

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // 피드 아이템들
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let _ = BNFont.loadFonts()
    MainView()
}
