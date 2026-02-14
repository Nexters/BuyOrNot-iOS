//
//  LoginView.swift
//  Auth
//
//  Created by 문종식 on 2/9/26.
//

import SwiftUI
import DesignSystem
import GoogleSignIn
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon

public struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                loginImage()
                loginTitle()
                loginButtonList()
                termText()
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                BNSnackBar(
                    item: viewModel.snackBar.currentItem,
                    state: $viewModel.snackBar.barState
                )
            }
        }
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
        .onOpenURL(
            perform: viewModel.handleAuthUrl
        )
    }
}



#Preview {
    LoginView(
        viewModel: LoginViewModel()
    )
    .onAppear {
        BNFont.loadFonts()
    }
}
