//
//  Color+Extenion.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI

public extension Color {
    static func source(_ source: BNColor.Source) -> Self {
        BNColor(source).color
    }
    
    static func type(_ type: BNColorType) -> Self {
        self.source(.type(type))
    }
    
    static func hex(_ hex: String) -> Self {
        self.source(.hex(hex))
    }
}


