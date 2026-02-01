//
//  BNSnackBarState.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import Foundation

public enum BNSnackBarState {
    case active
    case inactive
}

extension BNSnackBarState {
    var opacity: Double {
        switch self {
        case .active:
            return 1
        case .inactive:
            return 0
        }
    }
    
    var offsetY: CGFloat {
        switch self {
        case .active:
            return -4
        case .inactive:
            return 0
        }
    }
}
