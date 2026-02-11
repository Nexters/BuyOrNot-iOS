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
    
    var termText: AttributedString {
        viewModel.policyText.with { attributedString in
            attributedString.foregroundColor = BNColor(.type(.gray600)).color
        }
    }
    
    public init() {
        
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                BNImage(.login_background)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 40)
                VStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            BNColor(.type(.gray0)).color,
                            BNColor(.type(.gray0)).color.opacity(0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .layoutPriority(1)
                    
                    Spacer()
                        .layoutPriority(1)
                }
            }
            .offset(y: -40)
            
            BNText("현명한 소비를 위한\n합리적인 비교 방법")
                .style(style: .h1sb, color: .gray900)
                .padding(.top, 30)
                .padding(.bottom, 60)
            
            VStack(spacing: 12) {
                ForEach(LoginType.allCases, id: \.self) { type in
                    loginButton(type: type)
                }
            }
            .padding(.horizontal, 20)
            
            BNText(termText)
                .style(style: .c2m, color: .gray600)
                .multilineTextAlignment(.center)
                .onOpenURL { url in
                    // TODO:
                }
                .padding(.top, 30)
                .padding(.bottom, 40)
        }
        .ignoresSafeArea()
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
        .buttonStyle(LoginButtonStyle())
        .frame(height: 52)
    }
    
    private struct LoginButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration
                .label
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

#Preview {
    
    LoginView()
        .onAppear {
            BNFont.loadFonts()
        }
}
