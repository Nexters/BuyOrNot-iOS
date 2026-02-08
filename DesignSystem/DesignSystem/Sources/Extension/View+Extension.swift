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
    
    /// @inlinable nonisolated public func background<S>(_ style: S, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View where S : ShapeStyle
    func background(_ source: BNColor.Source) -> some View {
        self.background(.source(source))
    }
    func background(_ type: BNColorType) -> some View {
        self.background(.type(type))
    }
    func background(_ hex: String) -> some View {
        self.background(.hex(hex))
    }
}
