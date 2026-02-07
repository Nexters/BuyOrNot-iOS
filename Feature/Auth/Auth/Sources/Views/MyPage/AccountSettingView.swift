//
//  AccountSettingView.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import DesignSystem

public struct AccountSettingView: View {
    @StateObject var viewModel = AccountSettingViewModel()
    
    public init() {
        
    }
    
    public var body: some View {
        ScrollView {
            menus
        }
        .scrollBounceBehavior(
            .basedOnSize,
            axes: .vertical
        )
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
                        /// TODO: 작업 예정
                    },
                    BNAlertButtonConfig(
                        text: "유지하기",
                        type: .primary,
                    ) { },
                ]
            )
        )
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
                .style(style: .p2m, color: .type(.gray600))
        default:
            EmptyView()
        }
    }
}

#Preview {
    AccountSettingView()
}
