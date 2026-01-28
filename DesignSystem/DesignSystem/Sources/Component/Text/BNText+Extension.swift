//
//  BNText+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

extension BNText {
    /// BNText 전용 Style Modifier - BNColor
    public func style(
        _ style: BNFontStyle,
        _ color: BNColorType
    ) -> some View {
        self.modifier(
            BNTextStyle(
                style: style,
                color: BNColor(color)
            )
        )
    }
    
    /// BNText 전용 Style Modifier - Color
    public func style(
        _ style: BNFontStyle,
        _ color: Color
    ) -> some View {
        self.modifier(
            BNTextStyle(
                style: style,
                color: BNColor(color)
            )
        )
    }
    
    /// BNText 전용 Style Modifier - Hex String Color
    public func style(
        _ style: BNFontStyle,
        _ color: String
    ) -> some View {
        self.modifier(
            BNTextStyle(
                style: style,
                color: BNColor(hex: color)
            )
        )
    }
}
