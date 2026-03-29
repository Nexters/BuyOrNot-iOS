//
//  BNNavigationBar.swift
//  DesignSystem
//
//  Created by 이조은 on 3/9/26.
//

import SwiftUI

public struct BNNavigationBar: View {
    public enum LeadingItem {
        case back
        case close
    }

    private let leadingItem: LeadingItem
    private let title: String?
    private let onLeadingTap: () -> Void

    public init(
        leadingItem: LeadingItem = .back,
        title: String? = nil,
        onLeadingTap: @escaping () -> Void
    ) {
        self.leadingItem = leadingItem
        self.title = title
        self.onLeadingTap = onLeadingTap
    }

    public var body: some View {
        HStack(spacing: 0) {
            Button(action: onLeadingTap) {
                leadingIcon
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(ColorPalette.gray950)
                    .padding(10)
            }

            if let title {
                BNText(title)
                    .style(style: .t1b, color: ColorPalette.gray950)
            }

            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(height: 60)
    }

    private var leadingIcon: Image {
        switch leadingItem {
        case .back:
            BNImage(.left)
        case .close:
            BNImage(.close)
        }
    }
}
