//
//  BNImage.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import SwiftUI

public struct BNImage {
    @usableFromInline var asset: BNImageAsset
    
    public init(_ asset: BNImageAsset) {
        self.asset = asset
    }
    
    public var image: Image {
        Image(asset.rawValue, bundle: .module)
    }
    
    public var uiImage: UIImage {
        UIImage(named: asset.rawValue, in: .module, compatibleWith: nil) ?? UIImage()
    }
}
