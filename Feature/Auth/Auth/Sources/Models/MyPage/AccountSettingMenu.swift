//
//  AccountSettingMenu.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import DesignSystem

enum AccountSettingMenu: Hashable, CaseIterable, MenuTileItem {
    case email
    case logout
    case deleteAccount
    
    var title: String {
        switch self {
        case .email:
            "이메일"
        case .logout:
            "로그아웃"
        case .deleteAccount:
            "회원탈퇴"
        }
    }
    
    var hasAction: Bool {
        switch self {
        case .email:
            false
        case .logout, .deleteAccount:
            true
        }
    }
    
    var textColor: Color {
        switch self {
        case .email, .logout:
                .type(.gray900)
        case  .deleteAccount:
                .type(.red100)
        }
    }
}
