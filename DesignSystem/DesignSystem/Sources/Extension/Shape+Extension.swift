//
//  Shape+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 2/8/26.
//

import SwiftUI

public extension Shape {
    /// @inlinable nonisolated public func fill<S>(_ content: S, style: FillStyle = FillStyle()) -> some View where S : ShapeStyle
    func fill(_ source: BNColor.Source) -> some View {
        self.fill(.source(source))
    }
    
    func fill(_ type: BNColorType) -> some View {
        self.fill(.type(type))
    }

    func fill(_ hex: String) -> some View {
        self.fill(.hex(hex))
    }
}
