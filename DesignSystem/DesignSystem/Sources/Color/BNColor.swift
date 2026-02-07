//
//  BNColor.swift
//  DesignSystem
//
//  Created by 문종식 on 1/21/26.
//

import SwiftUI

public struct BNColor {
    public enum Source {
        case hex(String)
        case type(BNColorType)
    }
    
    private let _color: Color
    
    public var uiColor: UIColor {
        UIColor(_color)
    }
    
    public var color: Color {
        _color
    }
    
    public init(_ source: BNColor.Source) {
        switch source {
        case .hex(let hexString):
            var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            let isValidLength = hexSanitized.count == 6 || hexSanitized.count == 8
            
            var rgb: UInt64 = 0
            guard isValidLength, Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
                self._color = .clear
                return
            }

            let hasAlpha = hexSanitized.count == 8
            let red = Double((rgb & (hasAlpha ? 0x00FF0000 : 0xFF0000)) >> (hasAlpha ? 16 : 16)) / 255.0
            let green = Double((rgb & (hasAlpha ? 0x0000FF00 : 0x00FF00)) >> (hasAlpha ? 8 : 8)) / 255.0
            let blue = Double(rgb & (hasAlpha ? 0x000000FF : 0x0000FF)) / 255.0
            let alpha = hasAlpha ? Double((rgb & 0xFF000000) >> 24) / 255.0 : 1.0

            self._color = Color(red: red, green: green, blue: blue, opacity: alpha)
        case .type(let type):
            self._color = Color("\(type.name)", bundle: .module)
        }
    }
}
