//
//  UserEndpoint.swift
//  Service
//
//  Created by 문종식 on 2/15/26.
//

enum UserEndpoint: Endpoint {
    case getMe
    case deleteMe
    case patchFcmToken(UpdateFCMTokenRequest)
    case blockUser(Int)
    case getBlockedUsers
    case unblockUser(Int)

    var path: String {
        let prefix = "/users"
        let path = switch self {
        case .getMe, .deleteMe:
            "/me"
        case .patchFcmToken:
            "/fcm"
        case .blockUser(let userId), .unblockUser(let userId):
            "/blocks/\(userId)"
        case .getBlockedUsers:
            "/blocks"
        }
        return version.path + prefix + path
    }

    var method: HTTPMethod {
        switch self {
        case .getMe, .getBlockedUsers:
                .get
        case .deleteMe, .unblockUser:
                .delete
        case .patchFcmToken:
                .patch
        case .blockUser:
                .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .patchFcmToken(let body):
            return body
        default:
            return nil
        }
    }
}

struct UpdateFCMTokenRequest: Encodable {
    let fcmToken: String
}
