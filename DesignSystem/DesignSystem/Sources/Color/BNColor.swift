//
//  BNColor.swift
//  DesignSystem
//
//  Created by 문종식 on 1/21/26.
//

import SwiftUI

public struct BNColor {
    private let type: BNColorType?
    private let hex: String?
    
    public var color: Color {
        if let type = self.type {
            return Color("\(type.name)", bundle: .module)
        } else if let hex = self.hex {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            Scanner(string: hexSanitized).scanHexInt64(&rgb)

            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0

            return Color(red: red, green: green, blue: blue)
        }
        return .clear
    }
    
    public var uiColor: UIColor {
        UIColor(color)
    }
    
    public init(_ type: BNColorType) {
        self.type = type
        self.hex = nil
    }
    
    public init(hex: String) {
        self.type = nil
        self.hex = hex
    }
}
