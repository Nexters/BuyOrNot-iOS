//
//  MyPageView.swift
//  MyPage
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI
import DesignSystem
import Domain

public struct MyPageView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: MyPageViewModel

    public init(viewModel: MyPageViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            BNNavigationBar(onLeadingTap: { dismiss() })

            ScrollView {
                VStack(spacing: 0) {
                    profile
                    BNDivider(size: .s)
                        .padding(.vertical, 20)
                    menus
                    appVersion
                }
            }
            .scrollBounceBehavior(
                .basedOnSize,
                axes: .vertical
            )
        }
        .navigationBarHidden(true)
        .sheet(
            isPresented: Binding(
                get: { viewModel.url != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.url = nil
                    }
                }
            )
        ) {
            if let url = viewModel.url {
                BNWebView(url: url)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    @ViewBuilder
    private var profile: some View {
        HStack(spacing: 10) {
            BNImage(.camera)
                .frame(width: 42, height: 42)
            BNText(viewModel.name)
                .style(style: .s1sb, color: .gray900)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var menus: some View {
        VStack(spacing: 25) {
            ForEach(MyPageMenu.allCases, id: \.self) { menu in
                MenuTile(menu: menu) {
                    viewModel.didTapMenu(menu)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var appVersion: some View {
        HStack {
            BNText("앱버전")
                .style(style: .p4m, color: .gray600)
            Spacer()
            BNText("v \(viewModel.appVersion)")
                .style(style: .p4m, color: .gray600)
        }
        .padding(20)
    }
}


#Preview {
    MyPageView(
        viewModel: MyPageViewModel(
            userRepository: MockUserRepository(),
            argument: .init(
                navigator: MockAuthNavigator()
            )
        )
    )
}

private struct MockAuthNavigator: AuthNavigator {
    func navigateToTerms() {}
    func navigateToAccountSetting() {}
    func navigateToDeleteAccount() {}
    func navigateToBlockedAccounts() {}
    func navigateToLogin() {}
}

private final class MockUserRepository: UserRepository {
    func getCachedUser() -> User? {
        User(
            id: 0,
            nickname: "테스트유저",
            profileImage: "",
            socialAccount: "apple",
            email: "test@buyornot.com"
        )
    }
    
    func getMe() async throws -> User {
        User(
            id: 0,
            nickname: "테스트유저",
            profileImage: "",
            socialAccount: "apple",
            email: "test@buyornot.com"
        )
    }

    func updateFCMToken(_ token: String) async throws {}

    func deleteAccount() async throws {}

    func blockUser(userId: Int) async throws {}
    func getBlockedUsers() async throws -> [BlockedUser] { [] }
    func unblockUser(userId: Int) async throws {}
}
