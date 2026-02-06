//
//  PolicyMenu.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI

enum PolicyMenu: Hashable, CaseIterable, MenuTileItem {
    case privacy
    case service
    
    var title: String {
        switch self {
        case .privacy:
            "개인정보처리방침"
        case .service:
            "서비스 약관"
        }
    }
}
