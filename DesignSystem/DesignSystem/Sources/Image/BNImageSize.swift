//
//  BNImageSize.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import Foundation

public struct BNImageSize {
    public let width: CGFloat?
    public let height: CGFloat?
    
    public init(_ size: CGFloat) {
        self.width = size
        self.height = size
    }
    
    
    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
    
    public enum Icon {
        public static let size = BNImageSize(20)
    }
    
    public enum Profile {
        case small
        case medium
        case large
        
        public var size: BNImageSize {
            let value: CGFloat = switch self {
            case .small:  18
            case .medium: 32
            case .large:  42
            }
            return BNImageSize(value)
        }
    }
}
