//
//  BNSnackBarItem.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import SwiftUI

struct BNSnackBarIconConfig {
    let icon: BNImageAsset
    let color: Color
    
    init(
        icon: BNImageAsset,
        color: Color,
    ) {
        self.icon = icon
        self.color = color
    }
}

public struct BNSnackBarItem {
    let text: String
    let iconConfig: BNSnackBarIconConfig?
    
    public init(
        text: String,
        icon: BNImageAsset? = nil,
        color: Color? = nil
    ) {
        self.text = text
        if let icon, let color {
            self.iconConfig = BNSnackBarIconConfig(
                icon: icon,
                color: color
            )
        } else {
            self.iconConfig = nil
        }
    }
    
    static let empty: Self = .init(
        text: "",
    )
}
