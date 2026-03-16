//
//  MyPageViewModel.swift
//  MyPage
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI
import Core
import Domain

public final class MyPageViewModel: ObservableObject {
    private let userRepository: UserRepository
    private let navigator: AuthNavigator
    
    @Published var name: String = "이름입니다최대열자임"
    @Published var appVersion: String = "0.0.1"
    @Published var url: URL?
    
    public init(
        userRepository: UserRepository,
        argument: MyPageViewModel.Argument
    ) {
        self.userRepository = userRepository
        self.navigator = argument.navigator
    }
    
    func didTapMenu(_ menu: MyPageMenu) {
        switch menu {
        case .accountInfo:
            navigator.navigateToAccountSetting()
        case .blockingAccount:
            navigator.navigateToBlockedAccounts()
        case .terms:
            navigator.navigateToTerms()
        case .feedback:
            openFeedbackUrl()
        }
    }
    
    func onAppear() {
        Task { @MainActor [weak self] in
            do {
                let user = try await self?.userRepository.getMe()
                guard let nickname = user?.nickname else {
                    return
                }
                self?.name = nickname
            } catch {
            }
        }
    }
    
    private func openFeedbackUrl() {
        let urlString = Constants.getValue(with: .userFeedbackURL)
        guard let url = URL(string: urlString) else {
            return
        }
        self.url = url
    }
}

public extension MyPageViewModel {
    struct Argument {
        let navigator: AuthNavigator
        
        public init(navigator: AuthNavigator) {
            self.navigator = navigator
        }
    }
}
