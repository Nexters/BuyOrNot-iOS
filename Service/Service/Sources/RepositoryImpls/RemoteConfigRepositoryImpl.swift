//
//  RemoteConfigRepositoryImpl.swift
//  Service
//
//  Created by Codex on 3/31/26.
//

import Domain
import FirebaseRemoteConfig

public final class RemoteConfigRepositoryImpl: RemoteConfigRepository {
    private let remoteConfig: RemoteConfig

    public init(remoteConfig: RemoteConfig = .remoteConfig()) {
        self.remoteConfig = remoteConfig
    }
    
    public func fetchAndActivate() {
        remoteConfig.fetchAndActivate()
    }

    public func getString(forKey key: RemoteConfigKey) -> String {
        remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.remoteKey).stringValue
    }

    public func getBool(forKey key: RemoteConfigKey) -> Bool {
        remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.remoteKey).boolValue
    }

    public func getInt(forKey key: RemoteConfigKey) -> Int {
        remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.remoteKey).numberValue.intValue
    }

    public func getDouble(forKey key: RemoteConfigKey) -> Double {
        remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.remoteKey).numberValue.doubleValue
    }
}

private extension RemoteConfigKey {
    var remoteKey: String {
        switch self {
        case .iosMinSupportedVersion:
            return "ios_min_supported_version"
        }
    }
}
