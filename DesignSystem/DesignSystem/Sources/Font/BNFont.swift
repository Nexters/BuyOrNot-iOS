//
//  BNFont.swift
//  DesignSystem
//
//  Created by 문종식 on 1/21/26.
//

import SwiftUI

public struct BNFont {
    private static let fontName: String = "Pretendard"
    
    public static func font(_ style: BNFontStyle) -> Font {
        Font(uiFont(style))
    }
    
    public static func uiFont(_ style: BNFontStyle) -> UIFont {
        guard let font = UIFont(name: "\(fontName)-\(style.config.weight)", size: style.config.size) else {
            return .systemFont(ofSize: style.config.size)
        }
        return font
    }
    
    // Font Resource Load
    public static func loadFonts() {
        for fontWeight in BNFontWeight.allCases {
            registerFont(fontWeight: fontWeight)
        }
    }
    
    public static func registerFont(fontWeight: BNFontWeight) {
        guard let fontURL = Bundle.designSystem.url(
            forResource: "\(fontName)-\(fontWeight.rawValue)",
            withExtension: "otf",
        ) else {
            return
        }
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
    }
}
