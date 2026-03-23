//
//  View+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI

public extension View {
    /// @inlinable nonisolated public func background<Background>(_ background: Background, alignment: Alignment = .center) -> some View where Background : View
    func clearBackground() -> some View {
        self.background(ClearBackground())
    }
    
    /// @inlinable nonisolated public func font(_ font: Font?) -> some View
    func font(_ style: BNFontStyle) -> some View {
        self.font(BNFont.font(style))
    }
}
