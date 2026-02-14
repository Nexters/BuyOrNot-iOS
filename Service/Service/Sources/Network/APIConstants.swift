//
//  APIConstants.swift
//  Service
//
//  Created by 이조은 on 2/7/26.
//

import Foundation

public enum APIConstants {
    public static var baseURL: String? {
        Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
    }

    public static var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
