//
//  Text+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI

public extension Text {
    func font(_ style: BNFontStyle) -> Text {
        self.font(BNFont.font(style))
    }
}
