//
//  VoteGroup.swift
//  DesignSystem
//
//  Created by 이조은 on 1/28/26.
//

import SwiftUI

public struct VoteGroup: View {

    public struct VoteOption: Identifiable {
        public let id: Int
        public let text: String
        public let voteCount: Int
        public let imageURL: String?

        public init(
            id: Int,
            text: String,
            voteCount: Int,
            imageURL: String? = nil
        ) {
            self.id = id
            self.text = text
            self.voteCount = voteCount
            self.imageURL = imageURL
        }
    }

    private let options: [VoteOption]
    private let isPeriodDone: Bool
    private let selectedOptionId: Int?
    private let onVote: ((Int) -> Void)?

    // MARK: - Computed

    private var totalVotes: Int {
        options.reduce(0) { $0 + $1.voteCount }
    }

    private var winnerOptionId: Int? {
        options.max(by: { $0.voteCount < $1.voteCount })?.id
    }

    private var showResults: Bool {
        isPeriodDone || selectedOptionId != nil
    }

    private var isVotingEnabled: Bool {
        !isPeriodDone && selectedOptionId == nil
    }

    private var statusText: String {
        isPeriodDone ? "최종결과" : "진행중"
    }

    // MARK: - Initializer

    public init(
        options: [VoteOption],
        isPeriodDone: Bool = false,
        selectedOptionId: Int? = nil,
        onVote: ((Int) -> Void)? = nil
    ) {
        self.options = options
        self.isPeriodDone = isPeriodDone
        self.selectedOptionId = selectedOptionId
        self.onVote = onVote
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(options) { option in
                optionButton(for: option)
            }

            footerView
        }
        .allowsHitTesting(isVotingEnabled)
    }

    // MARK: - Subviews

    @ViewBuilder
    private func optionButton(for option: VoteOption) -> some View {
        let percent = calculatePercent(for: option)
        let isSelected = selectedOptionId == option.id

        VoteButton(
            text: option.text,
            imageURL: isSelected ? option.imageURL : nil,
            percent: percent,
            style: getStyle(for: option.id),
            showPercent: showResults,
            isPeriodDone: isPeriodDone
        ) {
            if isVotingEnabled {
                onVote?(option.id)
            }
        }
    }

    private var footerView: some View {
        Text("\(totalVotes)명이 투표했어요 ∙ \(statusText)")
            .font(BNFont.font(.b7m))
            .foregroundColor(BNColor(.type(.gray600)).color)
            .padding(.top, 2)
            .padding(.leading, 6)
    }

    // MARK: - Methods

    private func calculatePercent(for option: VoteOption) -> Int {
        guard totalVotes > 0 else { return 0 }
        return Int(round(Double(option.voteCount) / Double(totalVotes) * 100))
    }

    private func getStyle(for optionId: Int) -> VoteButtonStyle {
        if isPeriodDone {
            return optionId == winnerOptionId ? .black : .gray
        } else if let selected = selectedOptionId {
            return optionId == selected ? .black : .gray
        }
        return .plain
    }
}

// MARK: - Preview

#Preview("투표 전") {
    let _ = BNFont.loadFonts()

    struct Container: View {
        @State private var selectedId: Int? = nil

        var body: some View {
            VoteGroup(
                options: [
                    .init(id: 0, text: "사! 가즈아!", voteCount: 10, imageURL: "https://example.com/profile.jpg"),
                    .init(id: 1, text: "애매하긴 해..", voteCount: 90, imageURL: "https://example.com/profile.jpg")
                ],
                selectedOptionId: selectedId
            ) { optionId in
                withAnimation { selectedId = optionId }
            }
            .padding()
        }
    }

    return Container()
}

#Preview("최종 결과") {
    let _ = BNFont.loadFonts()

    VoteGroup(
        options: [
            .init(id: 0, text: "사! 가즈아!", voteCount: 10),
            .init(id: 1, text: "애매하긴 해..", voteCount: 90, imageURL: "https://example.com/profile.jpg")
        ],
        isPeriodDone: true,
        selectedOptionId: 1
    )
    .padding()
}
