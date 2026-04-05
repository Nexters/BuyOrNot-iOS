//
//  AppUpdateRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 4/5/26.
//

import Domain
import Foundation
import FirebaseRemoteConfig

public final class AppUpdateRepositoryImpl: AppUpdateRepository {
    private let remoteConfig: RemoteConfig
    private let store: AppUpdateStore

    public init(remoteConfig: RemoteConfig = .remoteConfig()) {
        self.remoteConfig = remoteConfig
        self.store = AppUpdateStore()
    }

    public func fetchAndActivate() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            remoteConfig.fetchAndActivate { _, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
            }
        }
    }

    public func getAppUpdateInfo() async -> AppUpdateInfo {
        try? await fetchAndActivate()
        let latestVersion = AppVersion(
            rawValue: remoteConfig.configValue(forKey: "ios_latest_version").stringValue
        )
        let minimumVersion = AppVersion(
            rawValue: remoteConfig.configValue(forKey: "ios_minimum_version").stringValue
        )
        let strategyString = remoteConfig.configValue(forKey: "ios_update_strategy").stringValue

        return AppUpdateInfo(
            latestVersion: latestVersion,
            minimumVersion: minimumVersion,
            updateStrategy: Self.parseUpdateStrategy(strategyString)
        )
    }

    public func shouldShowSoftUpdateToday() -> Bool {
        guard let lastShownDate = store.getLastSoftUpdateShownAt() else {
            return true
        }
        return !Calendar.current.isDateInToday(lastShownDate)
    }

    public func markSoftUpdateShown() {
        store.saveLastSoftUpdateShownAt(Date())
    }

    private static func parseUpdateStrategy(_ strategy: String) -> UpdateStrategy {
        switch strategy.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() {
        case "FORCE":
            return .force
        case "SOFT":
            return .soft
        default:
            return .none
        }
    }
}
