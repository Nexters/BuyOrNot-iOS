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
    func fetchAndActivate()
    func getString(forKey key: RemoteConfigKey) -> String
    func getBool(forKey key: RemoteConfigKey) -> Bool
    func getInt(forKey key: RemoteConfigKey) -> Int
    func getDouble(forKey key: RemoteConfigKey) -> Double
}
