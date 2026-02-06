//
//  Color+Extenion.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI

extension Color {
    static func bnType(_ type: BNColorType) -> Self {
        BNColor(.type(type)).color
    }
    
    static func hex(_ hex: String) -> Self {
        BNColor(.hex(hex)).color
    }
}
