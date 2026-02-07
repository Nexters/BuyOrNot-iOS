//
//  MenuTile.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//
import SwiftUI
import DesignSystem

struct MenuTile<TrailingContent: View>: View {
    private let menu: MenuTileItem
    private let action: () -> Void
    
    private let trailingItem: () -> TrailingContent
    
    init(
        menu: MenuTileItem,
        action: @escaping () -> Void,
        @ViewBuilder trailingItem: @escaping (() -> TrailingContent) = {
            EmptyView()
        }
    ) {
        self.menu = menu
        self.action = action
        self.trailingItem = trailingItem
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                BNText(menu.title)
                    .style(style: .p1m, color: menu.textColor)
                Spacer()
                trailingItem()
            }
            .padding(.vertical, 9)
            .contentShape(Rectangle())
        }
        .disabled(!menu.hasAction)
    }
}
