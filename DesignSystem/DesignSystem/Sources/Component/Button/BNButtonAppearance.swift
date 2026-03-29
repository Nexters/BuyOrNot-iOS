//
//  BNButtonAppearance.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import SwiftUI

struct BNButtonAppearance {
    let backgroundColor: Color
    let textColor: Color
    let textStyle: BNFontStyle
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let borderColor: Color
    let verticalPadding: CGFloat
    let horizontalPadding: CGFloat
    
    init(
        type: BNButtonType,
        state: BNButtonState,
    ) {
        switch type {
        case .primary:
            self.textStyle = .t2b
            self.cornerRadius = 14
            self.borderWidth = 0
            self.borderColor = .clear
            self.verticalPadding = 15
            self.horizontalPadding = 0
            switch state {
            case .enabled:
                self.backgroundColor = ColorPalette.gray950
                self.textColor = ColorPalette.gray0
            case .disabled:
                self.backgroundColor = ColorPalette.gray200
                self.textColor = ColorPalette.gray600
            }
        case .secondaryLarge:
            self.textStyle = .t2b
            self.cornerRadius = 14
            self.borderWidth = 0
            self.borderColor = .clear
            self.verticalPadding = 15
            self.horizontalPadding = 0
            switch state {
            case .enabled:
                self.backgroundColor = ColorPalette.gray300
                self.textColor = ColorPalette.gray700
            case .disabled:
                self.backgroundColor = ColorPalette.gray200
                self.textColor = ColorPalette.gray600
            }
        case .secondarySmall:
            self.textStyle = .s5sb
            self.cornerRadius = 10
            self.borderWidth = 0
            self.borderColor = .clear
            self.verticalPadding = 12
            self.horizontalPadding = 12
            switch state {
            case .enabled:
                self.backgroundColor = ColorPalette.gray100
                self.textColor = ColorPalette.gray700
            case .disabled:
                self.backgroundColor = ColorPalette.gray100
                self.textColor = ColorPalette.gray500
            }
        case .outline:
            self.textStyle = .s5sb
            self.cornerRadius = 10
            self.borderWidth = 1
            self.borderColor = ColorPalette.gray300
            self.verticalPadding = 12
            self.horizontalPadding = 12
            switch state {
            case .enabled:
                self.backgroundColor = ColorPalette.gray0
                self.textColor = ColorPalette.gray800
            case .disabled:
                self.backgroundColor = ColorPalette.gray0
                self.textColor = ColorPalette.gray500
            }
        case .capsule:
            self.textStyle = .s5sb
            self.cornerRadius = 20
            self.borderWidth = 0
            self.borderColor = .clear
            self.verticalPadding = 12
            self.horizontalPadding = 12
            switch state {
            case .enabled:
                self.backgroundColor = ColorPalette.gray950
                self.textColor = ColorPalette.gray0
            case .disabled:
                self.backgroundColor = ColorPalette.gray300
                self.textColor = ColorPalette.gray700
            }
        }
    }
}
