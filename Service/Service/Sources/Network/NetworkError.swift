//
//  NetworkError.swift
//  Service
//
//  Created by 이조은 on 2/7/26.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidBaseURL
    case noData
    case decodingFailed(Error)
    case encodingFailed
    case unauthorized  // 401
    case forbidden     // 403
    case notFound      // 404
    case serverError(statusCode: Int, data: Data? = nil)
    case requestFailed(Error)
    case unknown

    public var message: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidBaseURL:
            return "잘못된 BaseURL입니다."
        case .noData:
            return "데이터가 없습니다."
        case .decodingFailed(let error):
            return "데이터 파싱에 실패했습니다: \(error.localizedDescription)"
        case .encodingFailed:
            return "요청 데이터 인코딩에 실패했습니다."
        case .unauthorized:
            return "인증이 필요합니다. (401)"
        case .forbidden:
            return "접근 권한이 없습니다. (403)"
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다. (404)"
        case .serverError(let statusCode, let data):
            var message = "서버 오류가 발생했습니다. (\(statusCode))"
            #if DEBUG
            if let data = data, let errorString = String(data: data, encoding: .utf8) {
                message += "\n상세: \(errorString)"
            }
            #endif
            return message
        case .requestFailed(let error):
            return "요청 실패: \(error.localizedDescription)"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
