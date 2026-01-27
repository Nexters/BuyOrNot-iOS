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
        case .black: return BNColor(.gray900).color
        case .gray: return BNColor(.gray400).color
        case .plain: return BNColor(.gray0).color
        }
    }

    var textColor: Color {
        switch self {
        case .black: return BNColor(.gray0).color
        case .gray: return BNColor(.gray700).color
        case .plain: return BNColor(.gray900).color
        }
    }
}
