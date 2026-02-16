//
//  ImageInfo.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

public struct ImageInfo {
    public let uploadUrl: String
    public let s3ObjectKey: String
    public let viewUrl: String
    
    public init(uploadUrl: String, s3ObjectKey: String, viewUrl: String) {
        self.uploadUrl = uploadUrl
        self.s3ObjectKey = s3ObjectKey
        self.viewUrl = viewUrl
    }
}
