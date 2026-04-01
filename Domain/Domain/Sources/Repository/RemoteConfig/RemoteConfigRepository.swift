//
//  RemoteConfigRepository.swift
//  Domain
//
//  Created by Codex on 3/31/26.
//

public enum RemoteConfigKey {
    case iosMinSupportedVersion
}

public protocol RemoteConfigRepository {
    func fetchAndActivate() async throws
    func getString(forKey key: RemoteConfigKey) async -> String
    func getBool(forKey key: RemoteConfigKey) async -> Bool
    func getInt(forKey key: RemoteConfigKey) async -> Int
    func getDouble(forKey key: RemoteConfigKey) async -> Double
}
