//
//  PolicyView.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import DesignSystem

public struct PolicyView: View {
    @StateObject var viewModel = PolicyViewModel()
    
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
            ForEach(PolicyMenu.allCases, id: \.self) { menu in
                MenuTile(menu: menu) {
                    viewModel.didTapMenu(menu)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PolicyView()
}
