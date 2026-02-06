//
//  BNButtonAppearance.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import SwiftUI

struct BNButtonAppearance {
    let backgroundColor: BNColor.Source
    let textColor: BNColor.Source
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
                self.backgroundColor = .type(.gray900)
                self.textColor = .type(.gray0)
            case .disabled:
                self.backgroundColor = .type(.gray300)
                self.textColor = .type(.gray700)
            }
        case .secondary:
            self.textStyle = .s5sb
            self.cornerRadius = 10
            self.borderWidth = 0
            self.borderColor = .clear
            self.verticalPadding = 12
            self.horizontalPadding = 12
            switch state {
            case .enabled:
                self.backgroundColor = .type(.gray100)
                self.textColor = .type(.gray700)
            case .disabled:
                self.backgroundColor = .type(.gray100)
                self.textColor = .type(.gray500)
            }
        case .outline:
            self.textStyle = .s5sb
            self.cornerRadius = 10
            self.borderWidth = 1
            self.borderColor = BNColor(.type(.gray300)).color
            self.verticalPadding = 12
            self.horizontalPadding = 12
            switch state {
            case .enabled:
                self.backgroundColor = .type(.gray0)
                self.textColor = .type(.gray800)
            case .disabled:
                self.backgroundColor = .type(.gray0)
                self.textColor = .type(.gray500)
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
                self.backgroundColor = .type(.gray900)
                self.textColor = .type(.gray0)
            case .disabled:
                self.backgroundColor = .type(.gray300)
                self.textColor = .type(.gray700)
            }
        }
    }
}
