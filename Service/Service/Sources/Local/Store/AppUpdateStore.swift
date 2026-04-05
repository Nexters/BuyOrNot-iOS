//
//  AppUpdateStore.swift
//  Service
//
//  Created by 문종식 on 4/5/26.
//

import Foundation
import Domain
import FirebaseRemoteConfig

final class AppUpdateStore: EntityStore {
    let client: UserDefaultsClientProtocol
    let key: UserDefaultsKey = .appUpdate
    private let remoteConfig: RemoteConfig

    init(remoteConfig: RemoteConfig = .remoteConfig()) {
        self.client = UserDefaultsClient()
        self.remoteConfig = remoteConfig
    }

    func fetchAndActivate() async throws {
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

    func getLatestVersion() -> AppVersion {
        let key = RemoteConfigKey.iosLatestVersion.rawValue
        let value = remoteConfig.configValue(forKey: key).stringValue
        return AppVersion(rawValue: value)
    }

    func getMinimumVersion() -> AppVersion {
        let key = RemoteConfigKey.iosMinimumVersion.rawValue
        let value = remoteConfig.configValue(forKey: key).stringValue
        return AppVersion(rawValue: value)
    }

    func getUpdateStrategyRawValue() -> String {
        let key = RemoteConfigKey.iosUpdateStrategy.rawValue
        return remoteConfig.configValue(forKey: key).stringValue
    }

    func getLastSoftUpdateShownAt() -> Date? {
        let entity: AppUpdateEntity? = client.get(for: key)
        return entity?.lastSoftUpdateShownAt
    }

    func saveLastSoftUpdateShownAt(_ date: Date) {
        let entity = AppUpdateEntity(lastSoftUpdateShownAt: date)
        client.set(entity, for: key)
    }
}

private enum RemoteConfigKey: String {
    case iosLatestVersion = "ios_latest_version"
    case iosMinimumVersion = "ios_minimum_version"
    case iosUpdateStrategy = "ios_update_strategy"
}
