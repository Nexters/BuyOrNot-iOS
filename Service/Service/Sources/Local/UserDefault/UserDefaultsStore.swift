//
//  UserDefaultsStore.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Foundation

final class UserDefaultsStore {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set<T: Codable>(_ value: T, forKey key: String) {
        guard let data = try? encoder.encode(value) else {
            return
        }
        userDefaults.set(data, forKey: key)
    }
    
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return try? decoder.decode(type, from: data)
    }
    
    func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
