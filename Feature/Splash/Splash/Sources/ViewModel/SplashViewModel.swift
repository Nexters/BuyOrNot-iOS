//
//  SplashViewModel.swift
//  Splash
//
//  Created by 문종식 on 2/21/26.
//

import SwiftUI
import UIKit
import Core
import Domain
import DesignSystem

public final class SplashViewModel: ObservableObject {
    @Published var alertConfig: BNAlertConfig?

    private let tokenRepository: TokenRepository
    private let appUpdateRepository: AppUpdateRepository
    private let delegate: SplashDelegate?
    
    public init(
        tokenRepository: TokenRepository,
        appUpdateRepository: AppUpdateRepository,
        argument: SplashViewModel.Argument
    ) {
        self.tokenRepository = tokenRepository
        self.appUpdateRepository = appUpdateRepository
        self.delegate = argument.delegate
    }
    
    func didSplashStarted() async {
        try? await appUpdateRepository.fetchAndActivate()
    }
    
    func didSplashEnded() async {
        await routeAfterVersionCheck()
    }
    
    @MainActor
    private func routeAfterVersionCheck() async {
        let updateInfo = await appUpdateRepository.getAppUpdateInfo()
        let currentVersion = AppVersion(rawValue: Bundle.main.appVersionString)

        if currentVersion < updateInfo.minimumVersion {
            alertConfig = forceUpdateAlertConfig()
            return
        }

        if updateInfo.updateStrategy == .force {
            alertConfig = forceUpdateAlertConfig()
            return
        }

        if updateInfo.updateStrategy == .soft,
           currentVersion < updateInfo.latestVersion,
           appUpdateRepository.shouldShowSoftUpdateToday() {
            appUpdateRepository.markSoftUpdateShown()
            alertConfig = softUpdateAlertConfig()
            return
        }

        completeSplash()
    }
    
    func openAppStore() {
        let urlString = Constants.getValue(with: .appStoreURL)
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    private func didTapSoftUpdateLater() {
        completeSplash()
    }

    private func didTapSoftUpdateNow() {
        openAppStore()
        completeSplash()
    }

    private func completeSplash() {
        let token = tokenRepository.getToken()
        let authState: AuthState = token.isEmpty ? .guest : .member
        delegate?.completeSplash(authState)
    }

    private func forceUpdateAlertConfig() -> BNAlertConfig {
        BNAlertConfig(
            title: "필수 업데이트가 있어요",
            message: "서비스 이용을 위해 업데이트가 필요해요.",
            withClose: false,
            isEnableDismiss: false,
            buttons: [
                .init(
                    text: "업데이트",
                    type: .primary
                ) { [weak self] in
                    self?.openAppStore()
                }
            ]
        )
    }

    private func softUpdateAlertConfig() -> BNAlertConfig {
        BNAlertConfig(
            title: "새 버전이 출시됐어요",
            message: "더 나은 경험을 위해 업데이트를 권장해요.",
            buttons: [
                .init(
                    text: "나중에",
                    type: .secondaryLarge
                ) { [weak self] in
                    self?.didTapSoftUpdateLater()
                },
                .init(
                    text: "업데이트",
                    type: .primary
                ) { [weak self] in
                    self?.didTapSoftUpdateNow()
                }
            ]
        )
    }
}

public extension SplashViewModel {
    struct Argument {
        let delegate: SplashDelegate?
        
        public init(delegate: SplashDelegate?) {
            self.delegate = delegate
        }
    }
}
