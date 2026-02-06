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
