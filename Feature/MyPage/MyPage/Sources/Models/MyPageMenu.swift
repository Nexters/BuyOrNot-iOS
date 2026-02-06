//
//  MyPageMenu.swift
//  MyPage
//
//  Created by 문종식 on 1/18/26.
//

public enum MyPageMenu: Hashable, CaseIterable {
    case accountInfo
    case terms
    case feedback
    
    var title: String {
        switch self {
        case .accountInfo:
            "계정 정보"
        case .terms:
            "약관 및 정책"
        case .feedback:
            "의견 남기기"
        }
    }
}
