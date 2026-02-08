//
//  BNText+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

public extension BNText {
    /// BNText 전용 Style Modifier - BNColor
    func style(
        style: BNFontStyle,
        color: BNColor.Source
    ) -> some View {
        self.style(
            style: style,
            color: BNColor(color).color
        )
    }
    
    /// BNText 전용 Style Modifier - BNColorType
    func style(
        style: BNFontStyle,
        color: BNColorType
    ) -> some View {
        self.style(
            style: style,
            color: BNColor(.type(color)).color
        )
    }
    
    /// BNText 전용 Style Modifier - Color
    func style(
        style: BNFontStyle,
        color: Color
    ) -> some View {
        self.modifier(
            BNTextStyle(
                style: style,
                color: color
            )
        )
    }
}
