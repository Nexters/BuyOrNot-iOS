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

public final class SplashViewModel: ObservableObject {
    @Published var isRequireUpdate = false
    @Published var isSoftUpdate = false

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

    private func routeAfterVersionCheck() async {
        let updateInfo = await appUpdateRepository.getAppUpdateInfo()
        let currentVersion = AppVersion(rawValue: Bundle.main.appVersionString)

        if currentVersion < updateInfo.minimumVersion {
            isRequireUpdate = true
            return
        }

        if updateInfo.updateStrategy == .force {
            isRequireUpdate = true
            return
        }

        if updateInfo.updateStrategy == .soft,
           currentVersion < updateInfo.latestVersion,
           appUpdateRepository.shouldShowSoftUpdateToday() {
            appUpdateRepository.markSoftUpdateShown()
            isSoftUpdate = true
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
    
    func didTapSoftUpdateLater() {
        completeSplash()
    }

    func didTapSoftUpdateNow() {
        openAppStore()
        completeSplash()
    }

    private func completeSplash() {
        let token = tokenRepository.getToken()
        let authState: AuthState = token.isEmpty ? .guest : .member
        delegate?.completeSplash(authState)
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
