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
        case .black: return BNColor(.type(.gray900)).color
        case .gray: return BNColor(.type(.gray400)).color
        case .plain: return BNColor(.type(.gray0)).color
        }
    }

    var textColor: Color {
        switch self {
        case .black: return BNColor(.type(.gray0)).color
        case .gray: return BNColor(.type(.gray700)).color
        case .plain: return BNColor(.type(.gray900)).color
        }
    }
}
