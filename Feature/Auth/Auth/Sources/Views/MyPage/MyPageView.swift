//
//  MyPageView.swift
//  MyPage
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI
import DesignSystem

public struct MyPageView: View {
    @StateObject var viewModel = MyPageViewModel()
    
    public init() {
        
    }
    
    public var body: some View {
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
    
    @ViewBuilder
    private var profile: some View {
        HStack(spacing: 10) {
            BNImage(.camera)
                .frame(width: 42, height: 42)
            BNText(viewModel.name)
                .style(style: .s1sb, color: .type(.gray900))
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
                .style(style: .p4m, color: .type(.gray600))
            Spacer()
            BNText("v \(viewModel.appVersion)")
                .style(style: .p4m, color: .type(.gray600))
        }
        .padding(20)
    }
}


#Preview {
    MyPageView()
}
