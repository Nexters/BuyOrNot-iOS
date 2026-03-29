//
//  ColorPalette.swift
//  DesignSystem
//
//  Created by 문종식 on 3/23/26.
//

import SwiftUI

public enum ColorPalette {
    /// SNS Login
    public static let google = Color("google", bundle: .module)
    public static let apple = Color("apple", bundle: .module)
    public static let kakao = Color("kakao", bundle: .module)
    
    /// Black
    public static let black = Color("black", bundle: .module)
    
    /// Gray
    public static let gray0 = Color("gray0", bundle: .module)
    public static let gray50 = Color("gray50", bundle: .module)
    public static let gray100 = Color("gray100", bundle: .module)
    public static let gray200 = Color("gray200", bundle: .module)
    public static let gray300 = Color("gray300", bundle: .module)
    public static let gray400 = Color("gray400", bundle: .module)
    public static let gray500 = Color("gray500", bundle: .module)
    public static let gray600 = Color("gray600", bundle: .module)
    public static let gray700 = Color("gray700", bundle: .module)
    public static let gray800 = Color("gray800", bundle: .module)
    public static let gray900 = Color("gray900", bundle: .module)
    public static let gray950 = Color("gray950", bundle: .module)
    public static let gray1000 = Color("gray1000", bundle: .module)
    
    /// Green
    public static let green100 = Color("green100", bundle: .module)
    public static let green200 = Color("green200", bundle: .module)
    
    /// Red
    public static let red100 = Color("red100", bundle: .module)
    
    /// Blue
    public static let blue100 = Color("blue100", bundle: .module)
}

public extension ColorPalette {
    static func fromHex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        let isValidLength = hexSanitized.count == 6 || hexSanitized.count == 8
        
        var rgb: UInt64 = 0
        guard isValidLength, Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return .clear
        }

        let hasAlpha = hexSanitized.count == 8
        let red = Double((rgb & (hasAlpha ? 0x00FF0000 : 0xFF0000)) >> (hasAlpha ? 16 : 16)) / 255.0
        let green = Double((rgb & (hasAlpha ? 0x0000FF00 : 0x00FF00)) >> (hasAlpha ? 8 : 8)) / 255.0
        let blue = Double(rgb & (hasAlpha ? 0x000000FF : 0x0000FF)) / 255.0
        let alpha = hasAlpha ? Double((rgb & 0xFF000000) >> 24) / 255.0 : 1.0

        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}
