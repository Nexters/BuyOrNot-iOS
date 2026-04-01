//
//  BNAlertConfig.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

public struct BNAlertConfig {
    let title: String?
    let message: String?
    let withClose: Bool
    let buttons: [BNAlertButtonConfig]
    
    public init(
        title: String? = nil,
        message: String? = nil,
        withClose: Bool = true,
        buttons: [BNAlertButtonConfig]
    ) {
        self.title = title
        self.message = message
        self.withClose = withClose
        self.buttons = buttons
    }
}
