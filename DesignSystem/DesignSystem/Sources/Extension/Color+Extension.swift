//
//  Color+Extenion.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI

public extension Color {
    static func bnType(_ type: BNColorType) -> Self {
        BNColor(.type(type)).color
    }
    
    static func hex(_ hex: String) -> Self {
        BNColor(.hex(hex)).color
    }
}

public extension ShapeStyle where Self == Color {
    static func bnType(_ type: BNColorType) -> Color {
        Color.bnType(type)
    }

    static func hex(_ hex: String) -> Color {
        Color.hex(hex)
    }
}
