//
//  AccountSettingViewModel.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import Domain

public final class AccountSettingViewModel: ObservableObject {
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    private let localRepository: LocalRepository
    
    private let navigator: AuthNavigator
    @Published var email: String = "email@domain.com"
    @Published var showLogoutAlert: Bool = false

    public init(
        authRepository: AuthRepository,
        userRepository: UserRepository,
        localRepository: LocalRepository,
        argument: AccountSettingViewModel.Argument
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.localRepository = localRepository
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
    
    func onAppear() {
        Task { @MainActor [weak self] in
            do {
                let user = try await self?.userRepository.getMe()
                guard let email = user?.email else {
                    return
                }
                self?.email = email
            } catch {
            }
        }
    }
    
    func logout() {
        Task { @MainActor [weak self] in
            do {
                guard let token = self?.localRepository.getToken() else {
                    return
                }
                try await self?.authRepository.logout(refreshToken: token.refreshToken)
                self?.localRepository.removeToken()
                /// 성공하면 로그인 화면으로 이동
            } catch {
            }
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
