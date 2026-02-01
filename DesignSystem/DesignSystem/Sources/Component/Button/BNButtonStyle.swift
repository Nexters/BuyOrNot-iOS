//
//  BNButtonStyle.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import Foundation

public enum BNButtonStyle {
    case `default`
    case outline
    case round
}

extension BNButtonStyle {
    func backgroundColor(isEnabled: Bool) -> BNColorType {
        switch self {
        case .default: isEnabled ? .gray900 : .gray300
        case .outline: isEnabled ? .gray0 : .gray100
        case .round:   isEnabled ? .gray900 : .gray100
        }
    }
    
    func textColor(isEnabled: Bool) -> BNColorType {
        switch self {
        case .default: isEnabled ? .gray0 : .gray700
        case .outline: isEnabled ? .gray800 : .gray700
        case .round:   isEnabled ? .gray0 : .gray700
        }
    }
    
    var textStyle: BNFontStyle {
        switch self {
        case .default: .t2b
        case .outline: .s5sb
        case .round:   .s5sb
        }
    }
    
    var height: CGFloat {
        switch self {
        case .default: 50
        case .outline: 40
        case .round:   40
        }
    }
    
    var defaultWidth: CGFloat {
        switch self {
        case .default: 147
        case .outline: 65
        case .round:   65
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .default: 14
        case .outline: 10
        case .round:   height/2
        }
    }
    
    var borderColor: BNColorType? {
        switch self {
        case .default: nil
        case .outline: .gray300
        case .round:   nil
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .default: 0
        case .outline: 1
        case .round:   0
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .default: 15
        case .outline: 12
        case .round:   12
        }
    }
}
