//
//  VoteButton.swift
//  Vote
//
//  Created by 이조은 on 1/26/26.
//

import SwiftUI
import DesignSystem
import Kingfisher

public struct VoteButton: View {

    // MARK: - Properties

    let text: String
    let imageURL: String?
    let percent: Int
    let style: VoteButtonStyle
    let showPercent: Bool
    let isPeriodDone: Bool
    var action: (() -> Void)?

    @State private var animatedWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var didInitialDisplay = false

    private enum Layout {
        static let height: CGFloat = 46
        static let cornerRadius: CGFloat = 12
        static let horizontalPadding: CGFloat = 15
        static let verticalPadding: CGFloat = 14
        static let iconSize: CGFloat = 18
        static let spacing: CGFloat = 6
        static let animationDuration: Double = 0.6
    }

    public init(
        text: String,
        imageURL: String? = nil,
        percent: Int,
        style: VoteButtonStyle,
        showPercent: Bool,
        isPeriodDone: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.text = text
        self.imageURL = imageURL
        self.percent = percent
        self.style = style
        self.showPercent = showPercent
        self.isPeriodDone = isPeriodDone
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: { action?() }) {
            ZStack(alignment: .leading) {
                buttonContent(textColor: showPercent && style == .gray ? style.textColor : VoteButtonStyle.plain.textColor)
                    .background(VoteButtonStyle.plain.backgroundColor)

                if showPercent {
                    buttonContent(textColor: style.textColor)
                        .background(style.backgroundColor)
                        .mask(progressMask)
                }
            }
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear { containerWidth = geometry.size.width }
                        .onChange(of: geometry.size.width) { _, w in containerWidth = w }
                }
            }
        }
        .frame(height: 46)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .overlay(strokeBorder)
        .onChange(of: containerWidth) { _, newWidth in
            guard showPercent, newWidth > 0, !didInitialDisplay else { return }
            // 초기 로드: 이미 투표한 피드 → 애니메이션 없이 즉시 표시
            animatedWidth = newWidth * CGFloat(percent) / 100
            didInitialDisplay = true
        }
        .onChange(of: showPercent) { _, newValue in
            guard newValue else { animatedWidth = 0; didInitialDisplay = false; return }
            // 방금 투표: false→true 전환 → 애니메이션으로 표시
            didInitialDisplay = true
            let tw = containerWidth * CGFloat(percent) / 100
            Task { @MainActor in
                withAnimation(.easeInOut(duration: Layout.animationDuration)) {
                    animatedWidth = tw
                }
            }
        }
        .onChange(of: percent) { _, newPercent in
            guard showPercent, containerWidth > 0 else { return }
            let tw = containerWidth * CGFloat(newPercent) / 100
            if isPeriodDone {
                animatedWidth = tw
            } else {
                withAnimation(.easeInOut(duration: Layout.animationDuration)) {
                    animatedWidth = tw
                }
            }
        }
    }

    // MARK: - Subviews
    private func buttonContent(textColor: Color) -> some View {
        HStack(spacing: Layout.spacing) {
                BNText(text)
                    .style(style: .s4sb, color: textColor)

                Spacer(minLength: 0)

                if showPercent {
                    percentageView(textColor: textColor)
                }
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
    }

    @ViewBuilder
    private func percentageView(textColor: Color) -> some View {
        HStack(spacing: Layout.spacing) {
            if let urlString = imageURL, let url = URL(string: urlString) {
                userProfileImage(url: url)
            }

            BNText("\(percent)%")
                .style(style: .s4sb, color: textColor)
        }
    }

    private func userProfileImage(url: URL) -> some View {
        KFImage.url(url)
            .placeholder {
                Circle().fill(Color.gray.opacity(0.3))
            }
            .onFailureView {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
            }
            .resizable()
            .scaledToFill()
        .frame(width: Layout.iconSize, height: Layout.iconSize)
        .clipShape(Circle())
    }

    private var progressMask: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: didInitialDisplay
                           ? animatedWidth
                           : geo.size.width * CGFloat(percent) / 100)
                Spacer(minLength: 0)
            }
        }
    }

    private var strokeBorder: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius)
            .stroke(ColorPalette.gray300, lineWidth: 1)
    }


}
