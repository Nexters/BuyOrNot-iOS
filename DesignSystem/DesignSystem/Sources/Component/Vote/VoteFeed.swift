//
//  VoteFeed.swift
//  DesignSystem
//
//  Created by 이조은 on 1/31/26.
//

import SwiftUI

// MARK: - Models
/// TODO: 백엔드 API 응답 명세에 따라 구조 이동 및 변경 필요
public struct VoteFeedData {
    let id: String
    let userName: String
    let userProfileImageURL: String
    let category: String
    let timeAgo: String
    let content: String
    let productImageURL: String
    let price: String
    let voteOptions: [VoteGroup.VoteOption]

    public init(
        id: String,
        userName: String,
        userProfileImageURL: String,
        category: String,
        timeAgo: String,
        content: String,
        productImageURL: String,
        price: String,
        voteOptions: [VoteGroup.VoteOption]
    ) {
        self.id = id
        self.userName = userName
        self.userProfileImageURL = userProfileImageURL
        self.category = category
        self.timeAgo = timeAgo
        self.content = content
        self.productImageURL = productImageURL
        self.price = price
        self.voteOptions = voteOptions
    }
}

// MARK: - Main: VoteFeed
public struct VoteFeed: View {
    let data: VoteFeedData
    let onProductTap: () -> Void
    let onVote: (Int) -> Void

    @State private var selectedVoteId: Int?

    public init(
        data: VoteFeedData,
        selectedVoteId: Int? = nil,
        onProductTap: @escaping () -> Void = {},
        onVote: @escaping (Int) -> Void = { _ in }
    ) {
        self.data = data
        self._selectedVoteId = State(initialValue: selectedVoteId)
        self.onProductTap = onProductTap
        self.onVote = onVote
    }

    public var body: some View {
        VStack(spacing: 0) {
            Divider()
                .foregroundStyle(BNColor(.type(.gray200)).color)
                .frame(height: 2)

            VStack(spacing: 0) {
                FeedHeader(
                    userProfileImageURL: data.userProfileImageURL,
                    userName: data.userName,
                    category: data.category,
                    timeAgo: data.timeAgo,
                    onProductTap: onProductTap
                )
                .padding(.top, 20)

                FeedContent(
                    content: data.content,
                    productImageURL: data.productImageURL,
                    price: data.price,
                    voteOptions: data.voteOptions,
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
        }
    }
}

// MARK: - FeedHeader

private struct FeedHeader: View {
    let userProfileImageURL: String
    let userName: String
    let category: String
    let timeAgo: String
    let onProductTap: () -> Void

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
                    Text(userName)
                        .font(BNFont.font(.b6m))
                        .foregroundStyle(BNColor(.type(.gray800)).color)

                    BNImage(.right)
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(BNColor(.type(.gray600)).color)

                    Text(category)
                        .font(BNFont.font(.b6m))
                        .foregroundStyle(BNColor(.type(.gray800)).color)

                    Spacer()

                    Button(action: onProductTap) {
                        BNImage(.combined_shape)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(BNColor(.type(.gray500)).color)
                    }
                }

                Text(timeAgo)
                    .font(BNFont.font(.b7m))
                    .foregroundStyle(BNColor(.type(.gray600)).color)
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
    let selectedVoteId: Int?
    let onVote: (Int) -> Void

    private let horizontalPadding: CGFloat = 14

    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Text(content)
                    .font(BNFont.font(.p4m))
                    .foregroundStyle(BNColor(.type(.gray900)).color)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ProductImageCard(
                    imageURL: productImageURL,
                    price: price
                )

                VoteGroup(
                    options: voteOptions,
                    selectedOptionId: selectedVoteId,
                    onVote: onVote
                )
            }
            .padding(.vertical, 16)
            .padding(.horizontal, horizontalPadding)
        }
        .background(BNColor(.type(.gray100)).color)
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
                            Gradient.Stop(color: .black.opacity(0), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.6), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0.61),
                        endPoint: UnitPoint(x: 0.5, y: 1.0)
                    )
                )
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(price)
                    .font(BNFont.font(.t1b))
                    .foregroundColor(BNColor(.type(.gray0)).color)
                    .padding(.leading, 14)
                    .padding(.bottom, 16)
                    .shadow(
                        color: BNColor(.type(.gray1000)).color.opacity(0.4),
                        radius: 4,
                        x: 0,
                        y: 4
                    )

                VStack {
                    HStack {
                        Spacer()
                        NavigationLink {
                            FullScreenImageView(imageURL: imageURL)
                        } label: {
                            BNImage(.extend)
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(BNColor(.type(.gray300)).color)
                                .padding(8)
                                .background(BNColor(.type(.gray1000)).color.opacity(0.5))
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

    // NavigationStack으로 감싸야 push 동작함
    NavigationStack {
        VoteFeed(
            data: sampleData,
            onProductTap: { print("Product tapped") },
            onVote: { optionId in print("Voted for option: \(optionId)") }
        )
        .padding(.horizontal, 20)
    }
}
