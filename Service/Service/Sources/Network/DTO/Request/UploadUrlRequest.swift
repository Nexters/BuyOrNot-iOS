//
//  UploadUrlRequest.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

struct UploadUrlRequest: Encodable {
    let fileName: String
    let contentType: String
}
