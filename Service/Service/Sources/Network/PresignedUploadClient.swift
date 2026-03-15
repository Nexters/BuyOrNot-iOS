//
//  PresignedUploadClient.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

import Foundation

protocol PresignedUploadClientProtocol {
    func upload(data: Data, to uploadUrl: String, contentType: String) async throws
}

final class PresignedUploadClient: PresignedUploadClientProtocol {
    static let shared = PresignedUploadClient()

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func upload(data: Data, to uploadUrl: String, contentType: String) async throws {
        guard let url = URL(string: uploadUrl) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.timeoutInterval = 30
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        do {
            let (responseData, response) = try await session.upload(for: request, from: data)
            try validateResponse(response, data: responseData)
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }

    private func validateResponse(_ response: URLResponse, data: Data?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        switch httpResponse.statusCode {
        case 200...299:
            return
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }
    }
}
