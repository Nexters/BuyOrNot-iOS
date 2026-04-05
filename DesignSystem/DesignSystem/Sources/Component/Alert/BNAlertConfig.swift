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
    let isEnableDismiss: Bool
    let buttons: [BNAlertButtonConfig]
    
    public init(
        title: String? = nil,
        message: String? = nil,
        withClose: Bool = true,
        isEnableDismiss: Bool = true,
        buttons: [BNAlertButtonConfig]
    ) {
        self.title = title
        self.message = message
        self.withClose = withClose
        self.isEnableDismiss = isEnableDismiss
        self.buttons = buttons
    }

    func with(isEnableDismiss: Bool) -> BNAlertConfig {
        BNAlertConfig(
            title: title,
            message: message,
            withClose: withClose,
            isEnableDismiss: isEnableDismiss,
            buttons: buttons
        )
    }

    static var empty: BNAlertConfig {
        BNAlertConfig(buttons: [])
    }
}
