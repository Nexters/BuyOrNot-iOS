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

    private let tokenRepository: TokenRepository
    private let remoteConfigRepository: RemoteConfigRepository
    private let delegate: SplashDelegate?
    
    
    
    public init(
        tokenRepository: TokenRepository,
        remoteConfigRepository: RemoteConfigRepository,
        argument: SplashViewModel.Argument
    ) {
        self.tokenRepository = tokenRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.delegate = argument.delegate
    }
    
    func didSplashStarted() async {
        try? await remoteConfigRepository.fetchAndActivate()
    }
    
    func didSplashEnded() async {
        await routeAfterVersionCheck()
    }

    private func routeAfterVersionCheck() async {
        let minSupportedVersion = await remoteConfigRepository.getString(forKey: .iosMinSupportedVersion)
        isRequireUpdate = shouldRequireUpdate(minSupportedVersion: minSupportedVersion)

        if isRequireUpdate {
            return
        }
        
        let token = tokenRepository.getToken()
        let authState: AuthState = token.isEmpty ? .guest : .member
        delegate?.completeSplash(authState)
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
    
    // App 버전/최소 지원 버전 중 하나라도 파싱 실패하면 강제 업데이트로 처리한다.
    private func shouldRequireUpdate(minSupportedVersion: String) -> Bool {
        let versionKey = "CFBundleShortVersionString"
        guard
            let currentVersion = Bundle.main.infoDictionary?[versionKey] as? String,
            let current = parseVersion(currentVersion),
            let minimum = parseVersion(minSupportedVersion)
        else {
            return true
        }

        return current < minimum
    }

    // 버전 문자열은 반드시 "M.m.b" 형태(숫자 3개)여야 한다.
    private func parseVersion(_ version: String) -> (major: Int, minor: Int, build: Int)? {
        let components = version.split(separator: ".", omittingEmptySubsequences: false)
        guard components.count == 3 else { return nil }

        guard
            let major = Int(components[0]),
            let minor = Int(components[1]),
            let build = Int(components[2])
        else {
            return nil
        }

        return (major, minor, build)
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
