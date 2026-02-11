//
//  LoginView.swift
//  Auth
//
//  Created by 문종식 on 2/9/26.
//

import SwiftUI
import DesignSystem

public struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    public init() {
        
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            BNText("현명한 소비를 위한\n합리적인 비교 방법")
                .style(style: .h1b, color: .gray900)
                .padding(.top, 30)
                .padding(.bottom, 60)
            
            VStack(spacing: 12) {
                ForEach(LoginType.allCases, id: \.self) { type in
                    loginButton(type: type)
                }
            }
        }
    }
    
    @ViewBuilder
    private func loginButton(
        type: LoginType
    ) -> some View {
        Button {
            viewModel.login(with: type)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(type.backgroundColor)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .circular
                        )
                        .stroke(
                            type.borderColor,
                            lineWidth: 1
                        )
                    )
                HStack(spacing: 10) {
                    type.logo
                        .resizable()
                        .frame(width: 36, height: 36)
                    BNText(type.title)
                        .style(style: .b3m, color: type.fontColor)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

