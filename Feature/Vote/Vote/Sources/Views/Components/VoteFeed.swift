//
//  VoteFeed.swift
//  Vote
//
//  Created by 이조은 on 1/31/26.
//

import SwiftUI
import DesignSystem

// MARK: - Models
/// TODO: 백엔드 API 응답 명세에 따라 구조 이동 및 변경 필요
public struct VoteFeedData {
    public let id: String
    public let userId: Int
    public let userName: String
    public let userProfileImageURL: String
    public let category: String
    public let timeAgo: String
    public let content: String
    public let productImageURL: String
    public let price: String
    public let voteOptions: [VoteGroup.VoteOption]
    public let selectedVoteId: Int?
    public let isPeriodDone: Bool
    public let isMine: Bool
    public let isVotingLocked: Bool

    public init(
        id: String,
        userId: Int = 0,
        userName: String,
        userProfileImageURL: String,
        category: String,
        timeAgo: String,
        content: String,
        productImageURL: String,
        price: String,
        voteOptions: [VoteGroup.VoteOption],
        selectedVoteId: Int? = nil,
        isPeriodDone: Bool = false,
        isMine: Bool = false,
        isVotingLocked: Bool = false
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userProfileImageURL = userProfileImageURL
        self.category = category
        self.timeAgo = timeAgo
        self.content = content
        self.productImageURL = productImageURL
        self.price = price
        self.voteOptions = voteOptions
        self.selectedVoteId = selectedVoteId
        self.isPeriodDone = isPeriodDone
        self.isMine = isMine
        self.isVotingLocked = isVotingLocked
    }
}

// MARK: - Main: VoteFeed
public struct VoteFeed: View {
    let data: VoteFeedData
    let onDelete: () -> Void
    let onReport: () -> Void
    let onBlock: () -> Void
    let onVote: (Int) -> Void

    @State private var selectedVoteId: Int?
    @State private var showMenu: Bool = false
    @State private var showBlockAlert: Bool = false

    public init(
        data: VoteFeedData,
        selectedVoteId: Int? = nil,
        onDelete: @escaping () -> Void = {},
        onReport: @escaping () -> Void = {},
        onBlock: @escaping () -> Void = {},
        onVote: @escaping (Int) -> Void = { _ in }
    ) {
        self.data = data
        self._selectedVoteId = State(initialValue: selectedVoteId ?? data.selectedVoteId)
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
                    showMenu: $showMenu
                )
                .padding(.top, 20)

                FeedContent(
                    content: data.content,
                    productImageURL: data.productImageURL,
                    price: data.price,
                    voteOptions: data.voteOptions,
                    isPeriodDone: data.isPeriodDone,
                    isVotingLocked: data.isVotingLocked,
                    selectedVoteId: selectedVoteId,
                    onVote: { optionId in
                        withAnimation {
                            selectedVoteId = optionId
                        }
                        onVote(optionId)
                    }
                )
                .padding(.top, 14)
                .padding(.bottom, 20)
            }
            .overlay(alignment: .topTrailing) {
                if showMenu {
                    FloatingContextMenu(
                        menuButtons: data.isMine
                        ? [
                            FloatingContextMenuButton(
                                text: "삭제하기"
                            ) {
                                showMenu = false
                                onDelete()
                            }
                          ]
                        : [
                            FloatingContextMenuButton(
                                text: "신고하기"
                            ) {
                                showMenu = false
                                onReport()
                            },
                            FloatingContextMenuButton(
                                text: "차단하기"
                            ) {
                                showMenu = false
                                showBlockAlert = true
                            }
                          ]
                    )
                    .padding(.top, 50)
                    .padding(.trailing, 0)
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
                    BNAlertButtonConfig(
                        text: "차단하기",
                        type: .primary
                    ) {
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
    @Binding var showMenu: Bool

    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: URL(string: userProfileImageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
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

                BNText(timeAgo)
                    .style(style: .b7m, color: ColorPalette.gray600)
            }
        }
    }
}

// MARK: - FeedContent

private struct FeedContent: View {
    let content: String
    let productImageURL: String
    let price: String
    let voteOptions: [VoteGroup.VoteOption]
    let isPeriodDone: Bool
    let isVotingLocked: Bool
    let selectedVoteId: Int?
    let onVote: (Int) -> Void

    private let horizontalPadding: CGFloat = 14

    var body: some View {
        VStack {
            VStack(spacing: 12) {
                BNText(content)
                    .style(style: .p4m, color: ColorPalette.gray900)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ProductImageCard(
                    imageURL: productImageURL,
                    price: price
                )

                VoteGroup(
                    options: voteOptions,
                    isPeriodDone: isPeriodDone,
                    isVotingLocked: isVotingLocked,
                    selectedOptionId: selectedVoteId,
                    onVote: onVote
                )
            }
            .padding(.vertical, 16)
            .padding(.horizontal, horizontalPadding)
        }
        .background(ColorPalette.gray100)
        .cornerRadius(16)
    }
}

// MARK: - ProductImageCard

private struct ProductImageCard: View {
    let imageURL: String
    let price: String

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width

            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        /// TODO: 이미지 비율에 따라서 다르게 보이는 로직 추가 예정
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    default:
                        ProgressView()
                    }
                }
                .overlay(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: ColorPalette.black.opacity(0), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.1, green: 0.1, blue: 0.1), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0.61),
                        endPoint: UnitPoint(x: 0.5, y: 1.12)
                    )
                    .opacity(0.36)
                )
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                BNText(price)
                    .style(style: .t1b, color: ColorPalette.gray0)
                    .padding(.leading, 14)
                    .padding(.bottom, 16)

                VStack {
                    HStack {
                        Spacer()
                        NavigationLink {
                            FullScreenImageView(imageURL: imageURL)
                        } label: {
                            BNImage(.extend)
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(ColorPalette.gray300)
                                .padding(8)
                                .background(ColorPalette.gray1000.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 30, height: 30)
                        }
                        .padding([.top, .trailing], 14)
                    }
                    Spacer()
                }
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Preview
#Preview {
    let _ = BNFont.loadFonts()

    let sampleData = VoteFeedData(
        id: "1",
        userName: "userName",
        userProfileImageURL: "https://www.studiopeople.kr/common/img/default_profile.png",
        category: "category",
        timeAgo: "6시간 전",
        content: "본문 내용...",
        productImageURL: "https://www.locknlock.com/kor/image/story/lounge/ex/vr/tvahbryl/html/56994767otqf.jpg",
        price: "₩ 31,900",
        voteOptions: [
            .init(id: 0, text: "사! 가즈아!", voteCount: 10, imageURL: ""),
            .init(id: 1, text: "애매하긴 해..", voteCount: 90, imageURL: "")
        ]
    )

    NavigationStack {
        VoteFeed(
            data: sampleData,
            onDelete: { print("Delete tapped") },
            onReport: { print("Report tapped") },
            onVote: { optionId in print("Voted for option: \(optionId)") }
        )
        .padding(.horizontal, 20)
    }
}
