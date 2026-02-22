//
//  UserDefaultsClient.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Foundation

public protocol UserDefaultsClientProtocol {
    func get<T: Codable>(for key: UserDefaultsKey) -> T?
    func set<T: Codable>(_ value: T?, for key: UserDefaultsKey)
    func remove(for key: UserDefaultsKey)
    func clear()
}

final class UserDefaultsClient: UserDefaultsClientProtocol {
    private static let suiteName = "com.buyornot.app"
    public static let shared = UserDefaults(suiteName: suiteName) ?? .standard
    
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(
        userDefaults: UserDefaults = UserDefaultsClient.shared
    ) {
        self.userDefaults = userDefaults
    }
    
    func get<T: Codable>(for key: UserDefaultsKey) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            return nil
        }
        return try? decoder.decode(T.self, from: data)
    }
    
    func set<T: Codable>(_ value: T?, for key: UserDefaultsKey) {
        guard let value else {
            remove(for: key)
            return
        }
        guard let data = try? encoder.encode(value) else {
            return
        }
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    func remove(for key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    func clear() {
        UserDefaultsKey.allCases.forEach(remove(for:))
    }
}
