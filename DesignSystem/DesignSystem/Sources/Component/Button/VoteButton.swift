//
//  VoteButton.swift
//  DesignSystem
//
//  Created by 이조은 on 1/26/26.
//

import SwiftUI

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

    private enum Layout {
        static let height: CGFloat = 50
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
            GeometryReader { geometry in
                let targetWidth = geometry.size.width * CGFloat(percent) / 100

                ZStack(alignment: .leading) {
                    buttonContent(textColor: VoteButtonStyle.plain.textColor)
                            .background(VoteButtonStyle.plain.backgroundColor)

                    if showPercent {
                        buttonContent(textColor: style.textColor)
                            .background(style.backgroundColor)
                            .mask(progressMask)
                            .onAppear {
                                if isPeriodDone {
                                    animatedWidth = targetWidth
                                } else {
                                    animateProgress(to: targetWidth)
                                }
                            }
                    }
                }
            }
        }
        .frame(width: 307, height: 46)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .overlay(strokeBorder)
        .buttonStyle(.plain)
    }

    // MARK: - Subviews
    private func buttonContent(textColor: Color) -> some View {
        HStack(spacing: Layout.spacing) {
                Text(text)
                    .font(BNFont.font(.s4sb))
                    .foregroundColor(textColor)

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

            Text("\(percent)%")
                .font(BNFont.font(.s4sb))
                .foregroundColor(textColor)
        }
    }

    private func userProfileImage(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure:
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
            default:
                Circle().fill(Color.gray.opacity(0.3))
            }
        }
        .frame(width: Layout.iconSize, height: Layout.iconSize)
        .clipShape(Circle())
    }

    private var progressMask: some View {
        HStack(spacing: 0) {
            Rectangle().frame(width: animatedWidth)
            Spacer(minLength: 0)
        }
    }

    private var strokeBorder: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius)
            .stroke(BNColor(.gray300).color, lineWidth: 1)
    }

    // MARK: - Methods

    private func animateProgress(to targetWidth: CGFloat) {
        withAnimation(.easeInOut(duration: Layout.animationDuration)) {
            animatedWidth = targetWidth
        }
    }
}
