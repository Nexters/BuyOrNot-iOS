//
//  SplashView.swift
//  Splash
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI
import DesignSystem

public struct SplashView: View {
    @StateObject var viewModel: SplashViewModel
    
    public init(viewModel: SplashViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            BNLottie(
                asset: .splash,
                size: CGSize(width: 152, height: 152)
            ) { _ in }
                .onAppear {
                    Task {
                        viewModel.didSplashStarted()
                        try await Task.sleep(for: .milliseconds(2300))
                        viewModel.didSplashEnded()
                    }
                }
            
            BNImage(.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
        }
        .padding(.bottom, 320)
    }
}
