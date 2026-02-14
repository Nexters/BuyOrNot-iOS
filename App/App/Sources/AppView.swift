//
//  AppView.swift
//  App
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI
import Auth
import Splash

struct AppView: View {
    @State private var launchState: LaunchState = .main
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        switch launchState {
        case .splash:
            SplashView()
        case .login:
            LoginView(
                viewModel: container.resolve()
            )
        case .main:
            RootView()
        }
    }
}

#Preview {
    AppView()
}
