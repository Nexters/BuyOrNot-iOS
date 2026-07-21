//
//  NotificationBadge.swift
//  DesignSystem
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

public struct NotificationBadge: View {
    private let count: Int

    public init(count: Int) {
        self.count = count
    }

    public var body: some View {
        BNText(displayCount)
            .style(style: .c2r, color: ColorPalette.gray0)
            .lineLimit(1)
            .padding(.horizontal, count < 10 ? 6.5 : 4)
            .padding(.vertical, 2)
            .background {
                if count < 10 {
                    Circle()
                        .fill(ColorPalette.red100)
                } else {
                    Capsule()
                        .fill(ColorPalette.red100)
                }
            }
            .fixedSize(horizontal: true, vertical: true)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    private var displayCount: String {
        count > 99 ? "+99" : "\(count)"
    }
}

#Preview {
    let _ = BNFont.loadFonts()

    HStack(spacing: 12) {
        NotificationBadge(count: 1)
        NotificationBadge(count: 12)
        NotificationBadge(count: 120)
    }
    .padding()
}
