//
//  AppUpdateRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 4/5/26.
//

import Domain
import Foundation

public final class AppUpdateRepositoryImpl: AppUpdateRepository {
    private let store: AppUpdateStore

    public init() {
        self.store = AppUpdateStore()
    }

    public func fetchAndActivate() async throws {
        try await store.fetchAndActivate()
    }

    public func getAppUpdateInfo() async -> AppUpdateInfo {
        try? await fetchAndActivate()
        let latestVersion = store.getLatestVersion()
        let minimumVersion = store.getMinimumVersion()
        let strategyString = store.getUpdateStrategyRawValue()

        return AppUpdateInfo(
            latestVersion: latestVersion,
            minimumVersion: minimumVersion,
            updateStrategy: UpdateStrategy(remoteValue: strategyString)
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
}
