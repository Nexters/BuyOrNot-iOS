//
//  BNImageSize.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import Foundation

enum BNImageSize {
    enum Icon {
        static let size: CGFloat = 20
    }
    
    enum Profile {
        case small
        case medium
        case large
        
        var size: CGFloat {
            switch self {
            case .small:  18
            case .medium: 32
            case .large:  42
            }
        }
    }
}
