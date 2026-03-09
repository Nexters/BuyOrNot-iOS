//
//  PolicyView.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import DesignSystem

public struct PolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = PolicyViewModel()

    public init() {

    }

    public var body: some View {
        VStack(spacing: 0) {
            BNNavigationBar(title: "약관 및 정책", onLeadingTap: { dismiss() })

            ScrollView {
                menus
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
