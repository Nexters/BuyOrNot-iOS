//
//  ShapeStyle+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI

extension ShapeStyle {
    static func bnType(_ type: BNColorType) -> some ShapeStyle {
        Color.bnType(type)
    }
    
    static func hex(_ hex: String) -> some ShapeStyle {
        Color.hex(hex)
    }
}
