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
        case color(Color)
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

            var rgb: UInt64 = 0

            Scanner(string: hexSanitized).scanHexInt64(&rgb)

            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0

            self._color = Color(red: red, green: green, blue: blue)
        case .color(let color):
            self._color = color
        case .type(let type):
            self._color = Color("\(type.name)", bundle: .module)
        }
    }
}
