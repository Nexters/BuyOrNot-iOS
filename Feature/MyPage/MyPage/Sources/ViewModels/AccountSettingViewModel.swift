//
//  AccountSettingViewModel.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI

final class AccountSettingViewModel: ObservableObject {
    @Published var email: String = "email@domain.com"
    @Published var showLogoutAlert: Bool = false
    
    func didTapMenu(_ menu: AccountSettingMenu) {
        /// TODO: 작업 예정
        switch menu {
        case .email:
            break
        case .logout:
            toggleLogoutAlert()
        case .deleteAccount:
            break
        }
    }
    
    private func toggleLogoutAlert() {
        showLogoutAlert = true
    }
}
