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

    public func getString(forKey key: RemoteConfigKey) async -> String {
        try? await fetchAndActivate()
        return remoteConfig.configValue(forKey: key.remoteKey).stringValue
    }

    public func getBool(forKey key: RemoteConfigKey) async -> Bool {
        try? await fetchAndActivate()
        return remoteConfig.configValue(forKey: key.remoteKey).boolValue
    }

    public func getInt(forKey key: RemoteConfigKey) async -> Int {
        try? await fetchAndActivate()
        return remoteConfig.configValue(forKey: key.remoteKey).numberValue.intValue
    }

    public func getDouble(forKey key: RemoteConfigKey) async -> Double {
        try? await fetchAndActivate()
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
