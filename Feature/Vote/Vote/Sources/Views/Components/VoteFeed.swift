//
//  VoteFeed.swift
//  Vote
//
//  Created by 이조은 on 1/31/26.
//

import SwiftUI
import SafariServices
import DesignSystem
import Kingfisher

// MARK: - Models
/// TODO: 백엔드 API 응답 명세에 따라 구조 이동 및 변경 필요
public struct VoteFeedData {
    public let id: String
    public let userId: Int
    public let userName: String
    public let userProfileImageURL: String
    public let category: String
    public let timeAgo: String
    public let title: String?
    public let content: String
    public let productImageURLs: [String]
    public let price: String
    public let link: String?
    public let voteOptions: [VoteGroup.VoteOption]
    public let selectedVoteId: Int?
    public let isPeriodDone: Bool
    public let isMine: Bool
    public let isVotingLocked: Bool
    public let canShowMenu: Bool

    public init(
        id: String,
        userId: Int = 0,
        userName: String,
        userProfileImageURL: String,
        category: String,
        timeAgo: String,
        title: String? = nil,
        content: String,
        productImageURLs: [String],
        price: String,
        link: String? = nil,
        voteOptions: [VoteGroup.VoteOption],
        selectedVoteId: Int? = nil,
        isPeriodDone: Bool = false,
        isMine: Bool = false,
        isVotingLocked: Bool = false,
        canShowMenu: Bool = true
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userProfileImageURL = userProfileImageURL
        self.category = category
        self.timeAgo = timeAgo
        self.title = title
        self.content = content
        self.productImageURLs = productImageURLs
        self.price = price
        self.link = link
        self.voteOptions = voteOptions
        self.selectedVoteId = selectedVoteId
        self.isPeriodDone = isPeriodDone
        self.isMine = isMine
        self.isVotingLocked = isVotingLocked
        self.canShowMenu = canShowMenu
    }
}

// MARK: - Main: VoteFeed
public struct VoteFeed: View {
    let data: VoteFeedData
    let showLinkTooltip: Bool
    let onDelete: () -> Void
    let onReport: () -> Void
    let onBlock: () -> Void
    let onVote: (Int) -> Void

    @State private var selectedVoteId: Int?
    @State private var showMenu: Bool = false
    @State private var showBlockAlert: Bool = false

    public init(
        data: VoteFeedData,
        showLinkTooltip: Bool = false,
        onDelete: @escaping () -> Void = {},
        onReport: @escaping () -> Void = {},
        onBlock: @escaping () -> Void = {},
        onVote: @escaping (Int) -> Void = { _ in }
    ) {
        self.data = data
        self.showLinkTooltip = showLinkTooltip
        self._selectedVoteId = State(initialValue: data.selectedVoteId)
        self.onDelete = onDelete
        self.onReport = onReport
        self.onBlock = onBlock
        self.onVote = onVote
    }

    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                FeedHeader(
                    userProfileImageURL: data.userProfileImageURL,
                    userName: data.userName,
                    category: data.category,
                    timeAgo: data.timeAgo,
                    canShowMenu: data.canShowMenu,
                    showMenu: $showMenu
                )
                .padding(.top, 20)
                .padding(.horizontal, 20)

                FeedContent(
                    title: data.title,
                    content: data.content,
                    productImageURLs: data.productImageURLs,
                    price: data.price,
                    link: data.link,
                    showLinkTooltip: showLinkTooltip,
                    voteOptions: data.voteOptions,
                    isPeriodDone: data.isPeriodDone,
                    isVotingLocked: data.isVotingLocked,
                    selectedVoteId: selectedVoteId,
                    onVote: { optionId in
                        withAnimation { selectedVoteId = optionId }
                        onVote(optionId)
                    }
                )
                .padding(.bottom, 20)
            }
            .overlay(alignment: .topTrailing) {
                if showMenu {
                    FloatingContextMenu(
                        menuButtons: data.isMine
                        ? [
                            FloatingContextMenuButton(text: "삭제하기") {
                                showMenu = false
                                onDelete()
                            }
                        ]
                        : [
                            FloatingContextMenuButton(text: "신고하기") {
                                showMenu = false
                                onReport()
                            },
                            FloatingContextMenuButton(text: "차단하기") {
                                showMenu = false
                                showBlockAlert = true
                            }
                        ]
                    )
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                }
            }
            BNDivider(size: .s)
        }
        .bnAlert(
            isPresented: $showBlockAlert,
            isEnableDismiss: true,
            config: BNAlertConfig(
                title: "\(data.userName)님을 차단하시겠어요?",
                message: "차단한 사용자의 게시글은 더 이상 보이지 않아요.",
                buttons: [
                    .cancel,
                    BNAlertButtonConfig(text: "차단하기", type: .primary) {
                        onBlock()
                    }
                ]
            )
        )
    }
}

// MARK: - FeedHeader

private struct FeedHeader: View {
    let userProfileImageURL: String
    let userName: String
    let category: String
    let timeAgo: String
    let canShowMenu: Bool
    @Binding var showMenu: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            KFImage.url(URL(string: userProfileImageURL))
                .placeholder { ProgressView() }
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    BNText(userName)
                        .style(style: .b6m, color: ColorPalette.gray800)

                    BNImage(.right)
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(ColorPalette.gray600)

                    BNText(category)
                        .style(style: .b6m, color: ColorPalette.gray800)

                    Spacer()
                }

                BNText(timeAgo)
                    .style(style: .b7m, color: ColorPalette.gray600)
            }

            if canShowMenu {
                Button {
                    showMenu.toggle()
                } label: {
                    BNImage(.combined_shape)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(ColorPalette.gray500)
                }
            }
        }
    }
}

// MARK: - FeedContent

private struct FeedContent: View {
    let title: String?
    let content: String
    let productImageURLs: [String]
    let price: String
    let link: String?
    let showLinkTooltip: Bool
    let voteOptions: [VoteGroup.VoteOption]
    let isPeriodDone: Bool
    let isVotingLocked: Bool
    let selectedVoteId: Int?
    let onVote: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                if let title {
                    BNText(title)
                        .style(style: .s3sb, color: ColorPalette.gray950)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                BNText(content)
                    .style(style: .p3m, color: ColorPalette.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            if !productImageURLs.isEmpty {
                ProductImageCarousel(
                    imageURLs: productImageURLs,
                    price: price,
                    link: link,
                    showLinkTooltip: showLinkTooltip
                )
                .padding(.top, 12)
            }

            VoteGroup(
                options: voteOptions,
                isPeriodDone: isPeriodDone,
                isVotingLocked: isVotingLocked,
                selectedOptionId: selectedVoteId,
                onVote: onVote
            )
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }
}

private struct ProductImageCarousel: View {
    let imageURLs: [String]
    let price: String
    let link: String?
    let showLinkTooltip: Bool

    private let tooltipBg = Color(red: 0.23, green: 0.24, blue: 0.24).opacity(0.8)

    private var prefixedImages: [String] { Array(imageURLs.prefix(3)) }
    private var hasMultipleImages: Bool { prefixedImages.count > 1 }

    @State private var carouselHeight: CGFloat = UIScreen.main.bounds.width - 40
    @State private var visibleImageIndex: Int? = 0
    @State private var safariURL: URL?

    private var shouldShowLinkPill: Bool {
        !hasMultipleImages || visibleImageIndex == 0 || visibleImageIndex == nil
    }

    var body: some View {
        GeometryReader { geometry in
            let fullWidth = geometry.size.width
            let imageWidth = fullWidth - 40

            ZStack(alignment: .topLeading) {
                if hasMultipleImages {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(prefixedImages.enumerated()), id: \.offset) { index, url in
                                imageCell(url: url, size: imageWidth, showPrice: index == 0)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $visibleImageIndex)
                    .contentMargins(.horizontal, 20, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    .frame(width: fullWidth, height: imageWidth)
                } else if let url = prefixedImages.first {
                    ScrollView(.horizontal, showsIndicators: false) {
                        imageCell(url: url, size: imageWidth, showPrice: true)
                    }
                    .contentMargins(.horizontal, 20, for: .scrollContent)
                    .scrollDisabled(true)
                    .frame(width: fullWidth, height: imageWidth)
                }
            }
            .frame(width: fullWidth, height: imageWidth)
            .overlay(alignment: .topTrailing) {
                VStack(alignment: .trailing, spacing: 4) {
                    if shouldShowLinkPill {
                        indicatorPill
                            .padding(.trailing, 10)
                    }
                    if showLinkTooltip, link != nil, shouldShowLinkPill {
                        linkTooltipView
                    }
                }
                .padding(.top, 16)
                .padding(.trailing, 26)
            }
            .onAppear { carouselHeight = imageWidth }
        }
        .frame(maxWidth: .infinity)
        .frame(height: carouselHeight)
        .sheet(isPresented: Binding(
            get: { safariURL != nil },
            set: { if !$0 { safariURL = nil } }
        )) {
            if let url = safariURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    private func imageCell(url: String, size: CGFloat, showPrice: Bool) -> some View {
        ZStack(alignment: .bottomLeading) {
            KFImage.url(URL(string: url))
                .placeholder { Color(ColorPalette.gray200) }
                .onFailureView {
                    Color(ColorPalette.gray200)
                        .overlay {
                            BNImage(.product)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48)
                                .foregroundStyle(ColorPalette.gray400)
                        }
                }
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 14))

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.4), location: 1.0)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0.61),
                endPoint: UnitPoint(x: 0.5, y: 1.12)
            )
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .allowsHitTesting(false)

            if showPrice {
                BNText(price)
                    .style(style: .t1b, color: ColorPalette.gray0)
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
            }
        }
        .frame(width: size, height: size)
    }

    @ViewBuilder
    private var indicatorPill: some View {
        if let urlStr = link {
            Button {
                if let url = URL(string: urlStr) { safariURL = url }
            } label: {
                BNImage(.link)
                    .style(color: ColorPalette.gray0, size: 20)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.3))
            .clipShape(Capsule())
        }
    }

    private var linkTooltipView: some View {
        VStack(alignment: .trailing, spacing: 0) {
            LinkTooltipArrow()
                .fill(tooltipBg)
                .frame(width: 10, height: 5)
                .padding(.trailing, 23)

            BNText("상품 링크를 확인해보세요!")
                .style(style: .b5m, color: ColorPalette.gray0)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(tooltipBg)
                        }
                }
        }
    }
}

private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

private struct LinkTooltipArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
#Preview {
    let _ = BNFont.loadFonts()

    let sampleData = VoteFeedData(
        id: "1",
        userName: "참새방앗간12456",
        userProfileImageURL: "https://www.studiopeople.kr/common/img/default_profile.png",
        category: "패션 ∙ 잡화",
        timeAgo: "6시간 전",
        title: "장화 살지말지 고민됩니다",
        content: "이거 저 사봤는데 겁나 무겁고.. 그냥 그래요.. 근데 디자인은 진짜 이쁜데 일상에서 신기는 좀 애매한 것 같아요.",
        productImageURLs: [
            "https://www.locknlock.com/kor/image/story/lounge/ex/vr/tvahbryl/html/56994767otqf.jpg",
            "https://www.locknlock.com/kor/image/story/lounge/ex/vr/tvahbryl/html/56994767otqf.jpg"
        ],
        price: "₩ 31,900",
        link: "https://example.com/product",
        voteOptions: [
            .init(id: 0, text: "사! 가즈아!", voteCount: 10, imageURL: ""),
            .init(id: 1, text: "애매하긴 해..", voteCount: 90, imageURL: "")
        ]
    )

    NavigationStack {
        VoteFeed(
            data: sampleData,
            showLinkTooltip: true,
            onDelete: { print("Delete tapped") },
            onReport: { print("Report tapped") },
            onVote: { optionId in print("Voted for option: \(optionId)") }
        )
        .padding(.horizontal, 20)
    }
}
