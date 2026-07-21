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
            var transaction = Transaction(animation: nil)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                onTap()
            }
        } label: {
            BNText(title)
                .style(style: fontStyle, color: foregroundColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(height: 36)
                .background {
                    Capsule().fill(backgroundColor)
                }
                .overlay {
                    if state == .unselected {
                        Capsule()
                            .strokeBorder(ColorPalette.gray300, lineWidth: 1)
                    }
                }
                .animation(.none, value: state)
        }
        .buttonStyle(NoFeedbackButtonStyle())
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
    
    private var foregroundColor: Color {
        switch state {
        case .selected:
            return ColorPalette.gray0
        case .unselected, .hover:
            return ColorPalette.gray950
        }
    }
    
    private var backgroundColor: Color {
        switch state {
        case .selected:
            return ColorPalette.gray950
        case .unselected:
            return ColorPalette.gray0
        case .hover:
            return ColorPalette.gray200
        }
    }
}

private struct NoFeedbackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

// MARK: - Preview

#Preview {
    let _ = BNFont.loadFonts()
    let titles: [String] = [
        "Chip",
        "Long Long Chip",
        "한글칩",
        "엄청 긴 긴 한글칩",
    ]
    let states: [BNChip.ChipState] = [
        .selected,
        .unselected,
        .hover
    ]
    
    VStack {
        ForEach(titles, id: \.self) { title in
            HStack(spacing: 16) {
                ForEach(states, id: \.self) { state in
                    BNChip(
                        title: title,
                        state: state,
                        onTap: { print("\(state) tapped") }
                    )
                }
            }
        }
    }
    .padding()
}
