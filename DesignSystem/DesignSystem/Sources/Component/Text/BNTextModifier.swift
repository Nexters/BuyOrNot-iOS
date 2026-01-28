//
//  BNTextModifier.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

public struct BNTextStyle: ViewModifier {
    public let style: BNFontStyle
    public let color: BNColorType
    
    public init(style: BNFontStyle, color: BNColorType) {
        self.style = style
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .font(BNFont.font(style))
            .foregroundStyle(BNColor(color).color)
    }
}
