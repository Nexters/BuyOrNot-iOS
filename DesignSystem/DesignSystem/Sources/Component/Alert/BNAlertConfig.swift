//
//  BNAlertConfig.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

public struct BNAlertConfig {
    let title: String?
    let message: String
    let buttons: [BNAlertButtonConfig]
    
    public init(
        title: String?,
        message: String,
        buttons: [BNAlertButtonConfig]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}
