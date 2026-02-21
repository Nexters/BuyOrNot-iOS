//
//  UploadEndpoint.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

enum UploadEndpoint: Endpoint {
    case presignedPut(UploadUrlRequest)
    
    var path: String {
        let prefix = "/uploads"
        let path = switch self {
        case .presignedPut:
            "/presigned-put"
        }
        return version.path + prefix + path
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var body: (any Encodable)? {
        switch self {
        case .presignedPut(let uploadUrlRequest):
            uploadUrlRequest
        }
    }
}
