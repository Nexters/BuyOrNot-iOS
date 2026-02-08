//
//  ShapeStyle.swift
//  DesignSystem
//
//  Created by 문종식 on 2/8/26.
//

import SwiftUI

public extension ShapeStyle where Self == Color {
    static func source(_ source: BNColor.Source) -> Color {
        Color.source(source)
    }
    
    static func type(_ type: BNColorType) -> Color {
        self.source(.type(type))
    }

    static func hex(_ hex: String) -> Color {
        self.source(.hex(hex))
    }
}
