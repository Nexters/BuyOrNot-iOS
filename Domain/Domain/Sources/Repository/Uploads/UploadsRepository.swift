//
//  UploadsRepository.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

import Foundation

public protocol UploadsRepository {
    func postUploadImage(data: Data, fileName: String, contentType: String) async throws -> ImageInfo
}
