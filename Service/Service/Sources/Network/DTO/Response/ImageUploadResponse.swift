//
//  ImageUploadResponse.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

struct ImageUploadResponse: Decodable {
    let uploadUrl: String
    let s3ObjectKey: String
    let viewUrl: String
}
