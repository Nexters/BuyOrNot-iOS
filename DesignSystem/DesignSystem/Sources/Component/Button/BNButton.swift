//
//  BNButton.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import SwiftUI

public struct BNButton: View {
    let text: String
    let style: BNButtonStyle
    let isEnabled: Bool
    let action: () -> Void
    let width: CGFloat
    
    public init(
        text: String,
        style: BNButtonStyle,
        isEnabled: Bool,
        width: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.style = style
        self.isEnabled = isEnabled
        self.width = width ?? style.defaultWidth
        self.action = action
    }
    
    /// 폰트
    private var fontColor: BNColor.Source {
        .type(style.textColor(isEnabled: isEnabled))
    }
    
    /// 배경색
    private var backgroundColor: Color {
        BNColor(.type(style.backgroundColor(isEnabled: isEnabled))).color
    }
    
    /// 테두리색
    private var borderColor: Color {
        guard let borderColor = style.borderColor else {
            return .clear
        }
        return BNColor(.type(borderColor)).color
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            BNText(text)
                .style(
                    style: style.textStyle,
                    color: fontColor
                )
                .padding(.vertical, style.verticalPadding)
                .frame(
                    width: width,
                    height: style.height
                )
                .background {
                    RoundedRectangle(
                        cornerRadius: style.cornerRadius,
                        style: .circular
                    )
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: style.cornerRadius,
                            style: .circular
                        )
                        .stroke(
                            borderColor,
                            lineWidth: style.borderWidth
                        )
                    )
                }
            
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    let style: [BNButtonStyle] = [
        .default,
        .outline,
        .round
    ]
    let isEnabledFlags = [true, false]
    
    VStack(spacing: 15) {
        ForEach (0..<style.count, id: \.self) { index in
            ForEach (0..<isEnabledFlags.count, id: \.self) { isEnabledIndex in
                BNButton(
                    text: "Button",
                    style: style[index],
                    isEnabled: isEnabledFlags[isEnabledIndex]
                ) {
                    
                }
            }
        }
    }
}
