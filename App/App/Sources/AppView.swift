//
//  AppView.swift
//  App
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI
import Auth

struct AppView: View {
    @State private var launchState: LaunchState = .main

    var body: some View {
        switch launchState {
        case .splash:
            // TODO: 추후 SplashView()로 변경
            LoginView()
        case .login:
            LoginView()
        case .main:
            RootView()
        }
    }
}

#Preview {
    AppView()
}
