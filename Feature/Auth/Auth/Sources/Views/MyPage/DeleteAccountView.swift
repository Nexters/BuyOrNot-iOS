//
//  DeleteAccountView.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import DesignSystem
import Domain

public struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: DeleteAccountViewModel
    
    public init(viewModel: DeleteAccountViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                HStack {
                    BNText("\(viewModel.name)님,\n살까말까를 떠나시나요?")
                        .style(style: .h3b, color: .gray900)
                    Spacer()
                }
                HStack {
                    BNText(viewModel.guide)
                        .style(style: .p1m, color: .gray700)
                    Spacer()
                }
            }
            .padding(20)
            Spacer()
            BNButton(
                text: "탈퇴하기",
                type: .primary,
                state: .enabled
            ) {
                viewModel.didTapDeleteAccountButton()
            }
            .padding(20)
        }
        .bnAlert(
            isPresented: $viewModel.showDeleteAccountAlert,
            isEnableDismiss: true,
            config: BNAlertConfig(
                title: "정말 탈퇴하시겠어요?",
                buttons: [
                    BNAlertButtonConfig(
                        text: "탈퇴하기",
                        type: .secondaryLarge,
                    ) {
                        viewModel.deleteUser()
                    },
                    BNAlertButtonConfig(
                        text: "유지하기",
                        type: .primary,
                    ) {
                        dismiss()
                    },
                ]
            )
        )
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    DeleteAccountView(
        viewModel: DeleteAccountViewModel(
            userRepository: MockUserRepository(),
            localRepository: MockLocalRepository()
        )
    )
}

private final class MockUserRepository: UserRepository {
    func getMe() async throws -> User {
        User(
            id: 0,
            nickname: "테스트유저",
            profileImage: "",
            socialAccount: "apple",
            email: "test@buyornot.com"
        )
    }
    
    func deleteAccount() async throws {}
}

private final class MockLocalRepository: LocalRepository {
    func saveToken(_ token: Token) {}
    
    func getToken() -> Token {
        Token(refreshToken: "", accessToken: "", tokenType: "")
    }
    
    func removeToken() {}
}
