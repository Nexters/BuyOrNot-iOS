//
//  ImageUploadResponse+Extension.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

import Domain

extension ImageUploadResponse {
    func toDomain() -> ImageInfo {
        ImageInfo(
            uploadUrl: self.uploadUrl,
            s3ObjectKey: self.s3ObjectKey,
            viewUrl: self.viewUrl
        )
    }
}
