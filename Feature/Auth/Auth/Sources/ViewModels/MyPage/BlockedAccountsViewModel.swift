//
//  BlockedAccountsViewModel.swift
//  Auth
//
//  Created by Claude on 3/15/26.
//

import SwiftUI
import Domain
import DesignSystem

public final class BlockedAccountsViewModel: ObservableObject {
    private let userRepository: UserRepository

    @Published var blockedUsers: [BlockedUser] = []
    @Published var isLoading: Bool = false
    @Published var snackBar = BNSnackBarManager()

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    @MainActor
    func fetchBlockedUsers() async {
        isLoading = true
        do {
            blockedUsers = try await userRepository.getBlockedUsers()
        } catch {
            print("[BlockedAccountsViewModel] fetchBlockedUsers error: \(error)")
        }
        isLoading = false
    }

    @MainActor
    func unblockUser(_ user: BlockedUser) async {
        do {
            try await userRepository.unblockUser(userId: user.userId)
            blockedUsers.removeAll { $0.userId == user.userId }
            let item = BNSnackBarItem(
                text: "\(user.nickname)님이 차단 해제되었어요."
            )
            snackBar.addItem(item)
        } catch {
            print("[BlockedAccountsViewModel] unblockUser error: \(error)")
        }
    }
}
