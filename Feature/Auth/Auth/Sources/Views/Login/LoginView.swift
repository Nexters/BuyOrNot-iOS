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
    @StateObject  var viewModel = LoginViewModel()
    
    public init() {
        
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            loginImage()
            loginTitle()
            loginButtonList()
            termText()
        }
        .ignoresSafeArea()
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
    LoginView()
        .onAppear {
            BNFont.loadFonts()
        }
}
