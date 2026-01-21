//
//  BNFontStyle.swift
//  DesignSystem
//
//  Created by 문종식 on 1/21/26.
//

import SwiftUI

public enum BNFontStyle: String, CaseIterable {
    /// Display
    case d1b // Display/D1_Bold
    case d2b // Display/D2_Bold
    
    /// Heading
    case h1b // Heading/H1_Bold
    case h2b // Heading/H2_Bold
    case h3b // Heading/H3_Bold
    case h4b // Heading/H4_Bold
    case h1sb // Heading/H1_SemiBold
    
    /// Title
    case t1b // Title/T1_Bold
    case t2b // Title/T2_Bold
    case t3b // Title/T3_Bold
    case t4b // Title/T4_Bold
    
    /// SubTitle
    case s1sb // SubTitle/S1_Semibold
    case s2sb // SubTitle/S2_Semibold
    case s3sb // SubTitle/S3_Semibold
    case s4sb // SubTitle/S4_Semibold
    case s5sb // SubTitle/S5_Semibold
    
    /// Body
    case b1m // Body/B1_Medium
    case b2m // Body/B2_Medium
    case b3m // Body/B3_Medium
    case b4m // Body/B4_Medium
    case b5m // Body/B5_Medium
    case b6m // Body/B6_Medium
    case b7m // Body/B7_Medium
    
    /// Caption
    case c1m // Caption/C1_Medium
    case c2m // Caption/C2_Medium
    case c3m // Caption/C3_Medium
    case c1r // Caption/C1_Regular
    case c2r // Caption/C2_Regular
    case c3r // Caption/C3_Regular
    
    /// Paragraph
    case p1m // Paragraph/P1_Medium
    case p2m // Paragraph/P2_Medium
    case p3m // Paragraph/P3_Medium
    case p4m // Paragraph/P4_Medium
    case p1r // Paragraph/P1_Regular
    case p2r // Paragraph/P2_Regular
    case p3r // Paragraph/P3_Regular
    case p4r // Paragraph/P4_Regular
}

extension BNFontStyle {
    var config: (weight: BNFontWeight, size: CGFloat, lineHeight: CGFloat) {
        switch self {
            /// Display
        case .d1b: (.bold, 36, 36 * 1.5)
        case .d2b: (.bold, 32, 32 * 1.45)
            
            /// Heading
        case .h1b: (.bold, 28, 28 * 1.4)
        case .h2b: (.bold, 24, 24 * 1.4)
        case .h3b: (.bold, 22, 22 * 1.4)
        case .h4b: (.bold, 20, 20 * 1.35)
        case .h1sb: (.semibold, 24, 24 * 1.4)
            
            /// Title
        case .t1b: (.bold, 18, 18 * 1.25)
        case .t2b: (.bold, 16, 16 * 1.25)
        case .t3b: (.bold, 15, 15 * 1.25)
        case .t4b: (.bold, 14, 14 * 1.25)
            
            /// SubTitle
        case .s1sb: (.semibold, 18, 18 * 1.2)
        case .s2sb: (.semibold, 16, 16 * 1.25)
        case .s3sb: (.semibold, 15, 15 * 1.2)
        case .s4sb: (.semibold, 14, 14 * 1.25)
        case .s5sb: (.semibold, 13, 13 * 1.25)
            
            /// Body
        case .b1m: (.medium, 18, 18 * 1.25)
        case .b2m: (.medium, 16, 16 * 1.25)
        case .b3m: (.medium, 15, 15 * 1.25)
        case .b4m: (.medium, 14, 14 * 1.25)
        case .b5m: (.medium, 13, 13 * 1.25)
        case .b6m: (.medium, 12, 12 * 1.25)
        case .b7m: (.medium, 11, 11 * 1.25)
            
            /// Caption
        case .c1m: (.medium, 12, 12 * 1.4)
        case .c2m: (.medium, 11, 11 * 1.4)
        case .c3m: (.medium, 10, 10 * 1.4)
        case .c1r: (.regular, 12, 12 * 1.4)
        case .c2r: (.regular, 11, 11 * 1.4)
        case .c3r: (.regular, 10, 10 * 1.4)
            
            /// Paragraph
        case .p1m: (.medium, 16, 16 * 1.4)
        case .p2m: (.medium, 15, 15 * 1.4)
        case .p3m: (.medium, 14, 14 * 1.4)
        case .p4m: (.medium, 13, 13 * 1.4)
        case .p1r: (.regular, 16, 16 * 1.4)
        case .p2r: (.regular, 15, 15 * 1.4)
        case .p3r: (.regular, 14, 14 * 1.4)
        case .p4r: (.regular, 13, 13 * 1.4)
        }
    }
}
