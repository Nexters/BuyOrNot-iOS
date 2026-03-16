//
//  BlockedAccountsView.swift
//  Auth
//
//  Created by 이조은 on 3/15/26.
//

import SwiftUI
import DesignSystem
import Domain

public struct BlockedAccountsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: BlockedAccountsViewModel

    public init(viewModel: BlockedAccountsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                BNNavigationBar(title: "차단된 계정", onLeadingTap: { dismiss() })

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.blockedUsers.isEmpty {
                    Spacer()
                    BNText("차단된 계정이 없어요.")
                        .style(style: .b3m, color: .gray600)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.blockedUsers, id: \.userId) { user in
                                BlockedUserRow(user: user) {
                                    Task {
                                        await viewModel.unblockUser(user)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 26)
                    }
                    .scrollBounceBehavior(
                        .basedOnSize,
                        axes: .vertical
                    )
                }
            }

            VStack {
                Spacer()
                BNSnackBar(
                    item: viewModel.snackBar.currentItem,
                    state: $viewModel.snackBar.barState
                )
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchBlockedUsers()
        }
    }
}

// MARK: - BlockedUserRow

private struct BlockedUserRow: View {
    let user: BlockedUser
    let onUnblock: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 12) {
                profileImage
                BNText(user.nickname)
                    .style(style: .p2m, color: .gray900)
            }

            Spacer()

            BNChip(
                title: "차단해제",
                state: .selected,
                onTap: onUnblock
            )
        }
    }

    @ViewBuilder
    private var profileImage: some View {
        if user.profileImage.isEmpty {
            Circle()
                .fill(Color.type(.gray100))
                .overlay(
                    Circle()
                        .stroke(Color.type(.gray300), lineWidth: 1.3)
                )
                .overlay(
                    BNImage(.camera)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.type(.gray500))
                )
                .frame(width: 42, height: 42)
        } else {
            AsyncImage(url: URL(string: user.profileImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Color.type(.gray100))
                    .overlay(
                        Circle()
                            .stroke(Color.type(.gray300), lineWidth: 1.3)
                    )
            }
            .frame(width: 42, height: 42)
            .clipShape(Circle())
        }
    }
}

// MARK: - Preview

#Preview {
    let _ = BNFont.loadFonts()
    BlockedAccountsView(
        viewModel: BlockedAccountsViewModel(
            userRepository: MockBlockedUserRepository()
        )
    )
}

private final class MockBlockedUserRepository: UserRepository {
    func getMe() async throws -> User {
        User(id: 0, nickname: "테스트", profileImage: "", socialAccount: "", email: "")
    }
    func getCachedUser() -> User? { nil }
    func updateFCMToken(_ token: String) async throws {}
    func deleteAccount() async throws {}
    func blockUser(userId: Int) async throws {}
    func getBlockedUsers() async throws -> [BlockedUser] {
        [
            BlockedUser(userId: 1, nickname: "사용자1", profileImage: ""),
            BlockedUser(userId: 2, nickname: "사용자2", profileImage: ""),
            BlockedUser(userId: 3, nickname: "사용자3", profileImage: ""),
        ]
    }
    func unblockUser(userId: Int) async throws {}
}
