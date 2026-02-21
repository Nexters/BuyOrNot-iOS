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
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: AppViewModel
    
    init(viewModel: AppViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.launchState {
            case .splash:
                SplashView(
                    viewModel: container.resolve(
                        argument: viewModel
                    )
                )
            case .login:
                LoginView(
                    viewModel: container.resolve(
                        argument: viewModel
                    )
                )
            case .main:
                RootView()
            }
        }
    }
}
