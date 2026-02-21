//
//  AccountSettingViewModel.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI

public final class AccountSettingViewModel: ObservableObject {
    private let navigator: AuthNavigator
    @Published var email: String = "email@domain.com"
    @Published var showLogoutAlert: Bool = false

    public init(argument: AccountSettingViewModel.Argument) {
        self.navigator = argument.navigator
    }
    
    func didTapMenu(_ menu: AccountSettingMenu) {
        switch menu {
        case .email:
            break
        case .logout:
            toggleLogoutAlert()
        case .deleteAccount:
            navigator.navigateToDeleteAccount()
        }
    }
    
    private func toggleLogoutAlert() {
        showLogoutAlert = true
    }
}

public extension AccountSettingViewModel {
    struct Argument {
        let navigator: AuthNavigator
        
        public init(navigator: AuthNavigator) {
            self.navigator = navigator
        }
    }
}
