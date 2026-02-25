//
//  APIConstants.swift
//  Service
//
//  Created by 이조은 on 2/7/26.
//

import Foundation

public enum APIConstants {
    private enum BuildScheme {
        case debug
        case release
        var value: String {
            switch self {
            case .debug:
                "DEV_BASE_URL"
            case .release:
                "BASE_URL"
            }
        }
    }
    private static var buildScheme: BuildScheme {
        .release
    }
    
    public static var baseURL: String? {
        Bundle.main.object(
            forInfoDictionaryKey: buildScheme.value
        ) as? String
    }

    public static var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
