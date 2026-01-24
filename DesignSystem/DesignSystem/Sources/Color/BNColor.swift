//
//  BNColor.swift
//  DesignSystem
//
//  Created by 문종식 on 1/21/26.
//

import SwiftUI

public struct BNColor {
    private var type: BNColorType
    
    public var color: Color {
        Color("\(type.name)", bundle: .designSystem)
    }
    
    public var uiColor: UIColor {
        UIColor(color)
    }
    
    public init(_ type: BNColorType) {
        self.type = type
    }
}
