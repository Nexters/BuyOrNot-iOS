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
    
    /// Text Style Modifier  - BNColorType
    public init(style: BNFontStyle, color: BNColorType) {
        self.style = style
        self.color = BNColor(.type(color)).color
    }
    
    /// Text Style Modifier  - Hex String
    public init(style: BNFontStyle, color: String) {
        self.style = style
        self.color = BNColor(.hex(color)).color
    }
    
    /// Text Style Modifier  - Color
    public init(style: BNFontStyle, color: Color) {
        self.style = style
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .font(style)
            .foregroundStyle(color)
    }
}
