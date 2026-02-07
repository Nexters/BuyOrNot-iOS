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
            Text(title)
                .font(font)
                .foregroundColor(foregroundColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(height: 36)
                .background(backgroundColor)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Computed Properties
    private var font: Font {
        switch state {
        case .selected:
            return BNFont.font(.s5sb)
        case .unselected, .hover:
            return BNFont.font(.b5m)
        }
    }

    private var foregroundColor: Color {
        switch state {
        case .selected:
            return BNColor(.type(.gray0)).color
        case .unselected, .hover:
            return BNColor(.type(.gray700)).color
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .selected:
            return BNColor(.type(.gray900)).color
        case .unselected:
            return BNColor(.type(.gray200)).color
        case .hover:
            return BNColor(.type(.gray300)).color
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
