//
//  LoginType.swift
//  Auth
//
//  Created by 문종식 on 2/11/26.
//

import SwiftUI
import DesignSystem

enum LoginType: CaseIterable, Hashable {
    case google
    case apple
    case kakao
}

extension LoginType {
    /// 버튼 타이틀
    var title: String {
        switch self {
        case .google:
            "구글 계정으로 시작하기"
        case .apple:
            "Apple로 시작하기"
        case .kakao:
            "카카오로 시작하기"
        }
    }
    
    /// 버튼 Background Color
    var backgroundColor: Color {
        switch self {
        case .google:
            BNColor.init(.type(.google)).color
        case .apple:
            BNColor.init(.type(.apple)).color
        case .kakao:
            BNColor.init(.type(.kakao)).color
        }
    }
    
    /// 버튼 Border Color
    var borderColor: Color {
        switch self {
        case .google:
            BNColor.init(.type(.gray300)).color
        case .apple:
            BNColor.init(.type(.apple)).color
        case .kakao:
            BNColor.init(.type(.kakao)).color
        }
    }
    
    /// 버튼 로고 Image
    var logo: Image {
        switch self {
        case .google:
            BNImage(.google_logo)
        case .apple:
            BNImage(.apple_logo)
        case .kakao:
            BNImage(.kakao_logo)
        }
    }
    
    /// 버튼 타이틀 Color
    var fontColor: Color {
        switch self {
        case .google:
            BNColor.init(.type(.google)).color
        case .apple:
            BNColor.init(.type(.apple)).color
        case .kakao:
            BNColor.init(.type(.kakao)).color
        }
    }
    
    
}
