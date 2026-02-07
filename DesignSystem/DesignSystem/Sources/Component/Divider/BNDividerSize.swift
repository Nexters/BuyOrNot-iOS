//
//  BNDividerSize.swift
//  DesignSystem
//
//  Created by 문종식 on 2/2/26.
//

import Foundation

public enum BNDividerSize {
    case l // large
    case s // small
    
    var height: CGFloat {
        switch self {
        case .l:
            10
        case .s:
            2
        }
    }
}
