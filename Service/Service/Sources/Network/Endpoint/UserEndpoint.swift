//
//  UserEndpoint.swift
//  Service
//
//  Created by 문종식 on 2/15/26.
//

enum UserEndpoint: Endpoint {
    case getMe
    case deleteMe
    
    var path: String {
        let prefix = "/users"
        let path = switch self {
        case .getMe, .deleteMe:
            "/me"
        }
        return version.path + prefix + path
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMe:
                .get
        case .deleteMe:
                .delete
        }
    }
}
