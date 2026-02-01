//
//  BNSnackBarItem.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import Foundation

public struct BNSnackBarIconConfig {
    let icon: BNImageAsset
    let color: BNColor.Source
    let size: CGFloat
    
    public init(
        icon: BNImageAsset,
        color: BNColor.Source,
        size: CGFloat
    ) {
        self.icon = icon
        self.color = color
        self.size = size
    }
}

public struct BNSnackBarItem {
    let text: String
    let iconConfig: BNSnackBarIconConfig?
    
    public init(
        text: String,
        iconConfig: BNSnackBarIconConfig?
    ) {
        self.text = text
        self.iconConfig = iconConfig
    }
}
