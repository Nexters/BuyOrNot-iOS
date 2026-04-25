//
//  AccountSettingView.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import DesignSystem
import Domain

public struct AccountSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AccountSettingViewModel

    public init(viewModel: AccountSettingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            BNNavigationBar(title: "계정 설정", onLeadingTap: { dismiss() })

            ScrollView {
                menus
            }
            .scrollBounceBehavior(
                .basedOnSize,
                axes: .vertical
            )
            .padding(.top, 10)

        }
        .navigationBarHidden(true)
        .bnAlert(
            isPresented: $viewModel.showLogoutAlert,
            isEnableDismiss: true,
            config: BNAlertConfig(
                title: "로그아웃 하시겠어요?",
                buttons: [
                    BNAlertButtonConfig(
                        text: "로그아웃",
                        type: .secondaryLarge,
                    ) {
                        viewModel.logout()
                    },
                    BNAlertButtonConfig(
                        text: "유지하기",
                        type: .primary,
                    ) { },
                ]
            )
        )
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    @ViewBuilder
    private var menus: some View {
        VStack(spacing: 25) {
            ForEach(AccountSettingMenu.allCases, id: \.self) { menu in
                MenuTile(menu: menu) {
                    viewModel.didTapMenu(menu)
                } trailingItem: {
                    menuTrailingItem(menu: menu)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func menuTrailingItem(menu: AccountSettingMenu) -> some View {
        switch menu {
        case .email:
            BNText(viewModel.email)
                .style(style: .p2m, color: ColorPalette.gray600)
        default:
            EmptyView()
        }
    }
}
