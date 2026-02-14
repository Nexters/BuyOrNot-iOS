//
//  APIVersion.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

enum APIVersion: String {
    case v1
    
    var path: String {
        "/api/\(self.rawValue)"
    }
}
