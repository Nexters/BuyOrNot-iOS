//
//  UploadsRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

import Domain
import Foundation

public class UploadsRepositoryImpl: UploadsRepository {
    private let apiClient: NetworkClientProtocol
    private let uploadClient: PresignedUploadClientProtocol
    
    public init() {
        self.apiClient = NetworkClient.shared
        self.uploadClient = PresignedUploadClient.shared
    }

    init(
        apiClient: NetworkClientProtocol,
        uploadClient: PresignedUploadClientProtocol
    ) {
        self.apiClient = apiClient
        self.uploadClient = uploadClient
    }
    
    private func request<T: Decodable>(_ endpoint: UploadEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    public func postUploadImage(data: Data, fileName: String, contentType: String) async throws -> ImageInfo {
        let urlResponse: ImageUploadResponse = try await getUploadURL(
            fileName: fileName,
            contentType: contentType
        )

        try await uploadClient.upload(
            data: data,
            to: urlResponse.uploadUrl,
            contentType: contentType
        )

        return urlResponse.toDomain()
    }
    
    private func getUploadURL(fileName: String, contentType: String) async throws -> ImageUploadResponse {
        let body = UploadUrlRequest(
            fileName: fileName,
            contentType: contentType
        )
        let response: BaseResponse<ImageUploadResponse> = try await request(.presignedPut(body))
        return response.data
    }
}
