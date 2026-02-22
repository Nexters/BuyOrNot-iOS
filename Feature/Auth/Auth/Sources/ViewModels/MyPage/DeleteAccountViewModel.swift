//
//  DeleteAccountViewModel.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import Domain

public final class DeleteAccountViewModel: ObservableObject {
    private let userRepository: UserRepository
    private let tokenRepository: TokenRepository
    private let navigator: AuthNavigator
    
    @Published var name: String = "닉네임"
    @Published var guide: String = "지금까지의 투표들이 전부 사라져요 :("
    @Published var showDeleteAccountAlert: Bool = false
    
    public init(
        userRepository: UserRepository,
        tokenRepository: TokenRepository,
        argument: DeleteAccountViewModel.Argument
    ) {
        self.userRepository = userRepository
        self.tokenRepository = tokenRepository
        self.navigator = argument.navigator
    }
    
    func didTapDeleteAccountButton() {
        showDeleteAccountAlert.toggle()
    }
    
    func onAppear() {
        Task { @MainActor [weak self] in
            do {
                let user = try await self?.userRepository.getMe()
                if let nickname = user?.nickname {
                    self?.name = nickname
                }
            } catch {
                
            }
        }
    }
    
    func deleteUser() {
        Task { @MainActor [weak self] in
            do {
                try await self?.userRepository.deleteAccount()
                self?.tokenRepository.removeToken()
                self?.navigator.navigateToLogin()
            } catch {
                
            }
        }
    }
}

public extension DeleteAccountViewModel {
    struct Argument {
        let navigator: AuthNavigator
        
        public init(navigator: AuthNavigator) {
            self.navigator = navigator
        }
    }
}
