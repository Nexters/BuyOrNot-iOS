//
//  BNColorType.swift
//  DesignSystem
//
//  Created by 문종식 on 1/21/26.
//

public enum BNColorType: String {
    case black
    
    /// Gray
    case gray0
    case gray50
    case gray100
    case gray200
    case gray300
    case gray400
    case gray500
    case gray600
    case gray700
    case gray800
    case gray900
    case gray1000
    
    /// Green
    case green100
    case green200

    /// Red
    case red100
    
    /// Blue
    case blue100
}

extension BNColorType {
    var name: String {
        self.rawValue
    }
}
