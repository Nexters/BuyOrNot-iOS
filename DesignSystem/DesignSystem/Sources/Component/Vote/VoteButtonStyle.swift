//
//  VoteButtonStyle.swift
//  DesignSystem
//
//  Created by 이조은 on 1/28/26.
//

import SwiftUI

public enum VoteButtonStyle {
    case black
    case gray
    case plain

    var backgroundColor: Color {
        switch self {
        case .black: return ColorPalette.gray900
        case .gray: return ColorPalette.gray400
        case .plain: return ColorPalette.gray0
        }
    }

    var textColor: Color {
        switch self {
        case .black: return ColorPalette.gray0
        case .gray: return ColorPalette.gray700
        case .plain: return ColorPalette.gray900
        }
    }
}
