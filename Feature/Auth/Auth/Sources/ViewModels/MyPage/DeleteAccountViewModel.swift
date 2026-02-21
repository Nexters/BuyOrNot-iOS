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
    private let localRepository: LocalRepository
    
    @Published var name: String = "닉네임"
    @Published var guide: String = "지금까지의 투표들이 전부 사라져요 :("
    @Published var showDeleteAccountAlert: Bool = false
    
    public init(
        userRepository: UserRepository,
        localRepository: LocalRepository
    ) {
        self.userRepository = userRepository
        self.localRepository = localRepository
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
                self?.localRepository.removeToken()
                /// 성공하면 로그인 화면으로 이동
            } catch {
                
            }
        }
    }
}
