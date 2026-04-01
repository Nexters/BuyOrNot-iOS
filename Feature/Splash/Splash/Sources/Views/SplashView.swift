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
                        await viewModel.didSplashStarted()
                        try await Task.sleep(for: .milliseconds(2300))
                        await viewModel.didSplashEnded()
                    }
                }
            
            BNImage(.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
        }
        .padding(.bottom, 320)
        .bnAlert(
            isPresented: $viewModel.isRequireUpdate,
            isEnableDismiss: false,
            config: BNAlertConfig(
                title: "업데이트가 필요합니다.",
                message: "원활한 앱 사용을 위해 업데이트를 진행해주세요.",
                withClose: false,
                buttons: [
                    .init(
                        text: "업데이트",
                        type: .primary,
                        action: viewModel.openAppStore
                    )
                ]
            )
        )
    }
}
