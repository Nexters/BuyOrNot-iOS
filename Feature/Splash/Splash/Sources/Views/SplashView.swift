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
                title: "필수 업데이트가 있어요",
                message: "서비스 이용을 위해 업데이트가 필요해요.",
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
        .bnAlert(
            isPresented: $viewModel.isSoftUpdate,
            config: BNAlertConfig(
                title: "새 버전이 출시됐어요",
                message: "더 나은 경험을 위해 업데이트를 권장해요.",
                buttons: [
                    .init(
                        text: "나중에",
                        type: .secondaryLarge,
                        action: viewModel.didTapSoftUpdateLater
                    ),
                    .init(
                        text: "업데이트",
                        type: .primary,
                        action: viewModel.didTapSoftUpdateNow
                    )
                ]
            )
        )
    }
}
