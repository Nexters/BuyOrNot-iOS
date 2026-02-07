//
//  BNAlertButtonConfig.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

import Foundation

public struct BNAlertButtonConfig: Identifiable {
    public let id = UUID()
    let text: String
    let type: BNButtonType
    let action: () -> Void
    
    public init(
        text: String,
        type: BNButtonType,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.type = type
        self.action = action
    }
    
    public static var cancel: BNAlertButtonConfig {
        BNAlertButtonConfig(
            text: "취소",
            type: .secondaryLarge
        ) {
            
        }
    }
    
    public static var close: BNAlertButtonConfig {
        BNAlertButtonConfig(
            text: "닫기",
            type: .secondaryLarge
        ) {
            
        }
    }
}
