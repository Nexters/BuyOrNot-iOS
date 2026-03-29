//
//  BNChip.swift
//  DesignSystem
//
//  Created by 이조은 on 2/6/26.
//

import SwiftUI

public struct BNChip: View {
    public enum ChipState {
        case selected
        case unselected
        case hover
    }

    private let title: String
    private let state: ChipState
    private let onTap: () -> Void

    public init(
        title: String,
        state: ChipState = .unselected,
        onTap: @escaping () -> Void = {}
    ) {
        self.title = title
        self.state = state
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            onTap()
        } label: {
            BNText(title)
                .style(style: fontStyle, color: foregroundColorType)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(height: 36)
                .background(backgroundColor)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Computed Properties
    private var fontStyle: BNFontStyle {
        switch state {
        case .selected:
            return .s5sb
        case .unselected, .hover:
            return .b5m
        }
    }

    private var foregroundColorType: Color {
        switch state {
        case .selected:
            return ColorPalette.gray0
        case .unselected, .hover:
            return ColorPalette.gray700
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .selected:
            return ColorPalette.gray950
        case .unselected:
            return ColorPalette.gray200
        case .hover:
            return ColorPalette.gray300
        }
    }
}

// MARK: - Preview

#Preview {
    let _ = BNFont.loadFonts()

    HStack(spacing: 16) {
        BNChip(
            title: "Chip",
            state: .selected,
            onTap: { print("Selected tapped") }
        )

        BNChip(
            title: "Chip",
            state: .unselected,
            onTap: { print("Unselected tapped") }
        )

        BNChip(
            title: "Chip",
            state: .hover,
            onTap: { print("Hover tapped") }
        )
    }
    .padding()
}
