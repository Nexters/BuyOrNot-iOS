//
//  Banner.swift
//  DesignSystem
//
//  Created by 이조은 on 2/6/26.
//

import SwiftUI

public struct Banner: View {
    private let image: BNImageAsset
    private let text: String
    private let onClose: () -> Void
    private let onAction: () -> Void

    public init(
        image: BNImageAsset,
        text: String,
        onClose: @escaping () -> Void = {},
        onAction: @escaping () -> Void = {}
    ) {
        self.image = image
        self.text = text
        self.onClose = onClose
        self.onAction = onAction
    }

    public var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Button {
                    onClose()
                } label: {
                    BNImage(.close)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(BNColor(.type(.gray500)).color)
                }
            }
            .padding(.top, 8)
            .padding(.trailing, 24)

            ZStack {
                BNImage(image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 146)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            }
            .frame(width: 168, height: 92)
            .padding(.top, -14)

            Button {
                onAction()
            } label: {
                Text(text)
                    .font(BNFont.font(.s4sb))
                    .foregroundColor(BNColor(.type(.gray0)).color)
                    .frame(height: 44)
                    .padding(.horizontal, 82)
                    .background(
                        EllipticalGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.1, green: 0.11, blue: 0.13), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.54, green: 0.59, blue: 0.7), location: 2.00),
                            ],
                            center: UnitPoint(x: 0.46, y: 0.5)
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(height: 174)
        .padding(.top, 12)
        .padding(.bottom, 16)
        .background(BNColor(.type(.gray0)).color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 4)
        .overlay(
        RoundedRectangle(cornerRadius: 20)
        .inset(by: 0.5)
        .stroke(Color(red: 0.93, green: 0.94, blue: 0.95), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    let _ = BNFont.loadFonts()

    ZStack {
        Banner(
            image: .feed_banner,
            text: "고민되는 소비가 있나요?",
            onClose: { print("Close tapped") }
        )
        .padding(.horizontal, 20)
    }
}
