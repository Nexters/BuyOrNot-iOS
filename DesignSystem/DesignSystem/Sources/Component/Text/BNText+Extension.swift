//
//  BNText+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

extension BNText {
    /// BNText 전용 Style Modifier
    public func style(
        style: BNFontStyle,
        color: BNColor.Source
    ) -> some View {
        self.modifier(
            BNTextStyle(
                style: style,
                color: BNColor(color)
            )
        )
    }
}
