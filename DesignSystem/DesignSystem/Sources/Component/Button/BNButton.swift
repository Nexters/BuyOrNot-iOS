//
//  BNButton.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import SwiftUI

public struct BNButton: View {
    private let text: String
    private let type: BNButtonType
    @State private var state: BNButtonState
    private let width: CGFloat?
    private let action: () -> Void
    
    private var appearance: BNButtonAppearance {
        BNButtonAppearance(
            type: self.type,
            state: self.state
        )
    }
    
    private var backgroundColor: Color {
        BNColor(appearance.backgroundColor).color
    }
    
    public init(
        text: String,
        type: BNButtonType,
        state: BNButtonState,
        width: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.type = type
        self.state = state
        self.width = width
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            BNText(text)
                .style(
                    style: appearance.textStyle,
                    color: appearance.textColor
                )
                .padding(.vertical, appearance.verticalPadding)
                .padding(.horizontal, appearance.horizontalPadding)
                .frame(
                    width: width,
                )
                .background {
                    RoundedRectangle(
                        cornerRadius: appearance.cornerRadius,
                        style: .circular
                    )
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: appearance.cornerRadius,
                            style: .circular
                        )
                        .stroke(
                            appearance.borderColor,
                            lineWidth: appearance.borderWidth
                        )
                    )
                }
        }
        .buttonStyle(BNButtonStyle())
        .disabled(state == .disabled)
    }
}

private struct BNButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    let type: [BNButtonType] = [
        .primary,
        .secondary,
        .outline,
        .capsule,
    ]
    
    let state: [BNButtonState] = [
        .enabled,
        .disabled
    ]
    
    VStack(spacing: 15) {
        ForEach (0..<type.count, id: \.self) { t in
            ForEach (0..<state.count, id: \.self) { s in
                BNButton(
                    text: "Button",
                    type: type[t],
                    state: state[s],
                    width: type[t] == .primary ? 147 : nil,
                ) {
                    
                }
            }
        }
    }
}
