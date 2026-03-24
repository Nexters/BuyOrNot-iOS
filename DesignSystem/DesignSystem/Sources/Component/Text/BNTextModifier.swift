//
//  BNTextModifier.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

public struct BNTextStyle: ViewModifier {
    private let style: BNFontStyle
    private let color: Color
    
    public init(style: BNFontStyle, color: Color) {
        self.style = style
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        let uiFont = BNFont.uiFont(style)
        let targetLineHeight = style.config.size * style.config.lineHeightRatio
        let lineSpacing = targetLineHeight - uiFont.lineHeight

        content
            .font(style)
            .foregroundStyle(color)
            .lineSpacing(lineSpacing)
            .padding(.vertical, lineSpacing / 2)
    }
}
