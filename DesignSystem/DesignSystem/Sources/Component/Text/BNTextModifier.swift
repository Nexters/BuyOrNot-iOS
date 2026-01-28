//
//  BNTextModifier.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

public struct BNTextStyle: ViewModifier {
    private let style: BNFontStyle
    private let color: BNColor
    
    public init(style: BNFontStyle, color: BNColor) {
        self.style = style
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .font(BNFont.font(style))
            .foregroundStyle(color.color)
    }
}
