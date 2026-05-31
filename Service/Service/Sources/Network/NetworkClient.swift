//
//  NetworkClient.swift
//  Service
//
//  Created by 이조은 on 2/7/26.
//

import Foundation
import Core

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws -> Void
}

final class NetworkClient: NetworkClientProtocol {
    public static let shared = NetworkClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let tokenStore: TokenStore
    private let userStore: UserStore

    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        tokenStore: TokenStore = TokenStore(),
        userStore: UserStore = UserStore()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.tokenStore = tokenStore
        self.userStore = userStore
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await request(endpoint, didRetryAfterRefresh: false)
    }

    public func request(_ endpoint: Endpoint) async throws -> Void {
        try await request(endpoint, didRetryAfterRefresh: false)
    }

    // MARK: - Private Methods

    private func request<T: Decodable>(
        _ endpoint: Endpoint,
        didRetryAfterRefresh: Bool
    ) async throws -> T {
        let urlRequest = try buildRequest(from: endpoint)

        do {
            let (data, response) = try await session.data(for: urlRequest)

            try validateResponse(response, data: data)

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                bnPrint("🚨 Decoding failed: \(error)")
                if let jsonString = data.prettyPrintedJSON {
                    bnPrint("📦 Response data:\n\(jsonString)")
                }
                throw NetworkError.decodingFailed(error)
            }
        } catch let error as NetworkError {
            if case .unauthorized = error,
               shouldRetryAfterRefresh(for: endpoint, didRetryAfterRefresh: didRetryAfterRefresh) {
                try await refreshAccessToken()
                return try await request(endpoint, didRetryAfterRefresh: true)
            }
            throw error
        } catch {
            bnPrint("🚨 Network request failed: \(error.localizedDescription)")
            throw NetworkError.requestFailed(error)
        }
    }

    private func request(
        _ endpoint: Endpoint,
        didRetryAfterRefresh: Bool
    ) async throws {
        let urlRequest = try buildRequest(from: endpoint)

        do {
            let (data, response) = try await session.data(for: urlRequest)

            try validateResponse(response, data: data)
        } catch let error as NetworkError {
            if case .unauthorized = error,
               shouldRetryAfterRefresh(for: endpoint, didRetryAfterRefresh: didRetryAfterRefresh) {
                try await refreshAccessToken()
                try await request(endpoint, didRetryAfterRefresh: true)
                return
            }
            throw error
        } catch {
            bnPrint("🚨 Network request failed: \(error.localizedDescription)")
            throw NetworkError.requestFailed(error)
        }
    }

    private func shouldRetryAfterRefresh(for endpoint: Endpoint, didRetryAfterRefresh: Bool) -> Bool {
        !didRetryAfterRefresh && !isRefreshEndpoint(endpoint)
    }

    private func isRefreshEndpoint(_ endpoint: Endpoint) -> Bool {
        guard let authEndpoint = endpoint as? AuthEndpoint else {
            return false
        }
        if case .postRefreshToken = authEndpoint {
            return true
        }
        return false
    }

    private func refreshAccessToken() async throws {
        let refreshToken = tokenStore.getToken()?.refreshToken ?? ""
        guard refreshToken.isNotEmpty else {
            invalidateAuthSession()
            throw NetworkError.unauthorized
        }
        let endpoint = AuthEndpoint.postRefreshToken(
            RefreshTokenRequest(refreshToken: refreshToken)
        )
        do {
            let response: BaseResponse<AuthSessionResponse> = try await request(
                endpoint,
                didRetryAfterRefresh: false
            )
            let session = response.data.toDomain()
            tokenStore.saveToken(session.token)
            userStore.saveUser(session.user)
        } catch {
            invalidateAuthSession()
            throw error
        }
    }

    private func invalidateAuthSession() {
        tokenStore.removeToken()
        userStore.removeUser()
        NotificationCenter.default.post(name: .authSessionDidExpire, object: nil)
    }

    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let baseURL = endpoint.baseURL else {
            bnPrint("🚨 Invalid Base URL: baseURL is null")
            throw NetworkError.invalidBaseURL
        }
        
        guard var urlComponents = URLComponents(string: baseURL + endpoint.path) else {
            bnPrint("🚨 Invalid URL: \(baseURL + endpoint.path)")
            throw NetworkError.invalidURL
        }

        if let queryParameters = endpoint.queryParameters {
            var queryItems: [URLQueryItem] = []
            for (key, value) in queryParameters {
                if let array = value as? [Any] {
                    array.forEach { queryItems.append(URLQueryItem(name: key, value: "\($0)")) }
                } else {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            bnPrint("🚨 Failed to create URL from components")
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 30

        APIConstants.defaultHeaders.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        endpoint.headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        let accessToken = tokenStore.getToken()?.accessToken ?? ""
        if accessToken.isNotEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        if let body = endpoint.body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                bnPrint("🚨 Encoding failed: \(error)")
                throw NetworkError.encodingFailed
            }
        }

        bnPrint("\n🌐 [\(endpoint.method.rawValue)] \(url.absoluteString)")
        if let httpBody = request.httpBody,
           let bodyString = String(data: httpBody, encoding: .utf8) {
            bnPrint("📤 Request Body: \(bodyString)")
        }
        if let headers = endpoint.headers {
            bnPrint("📋 Custom Headers: \(headers)")
        }
        bnPrint("🔑 Bearer Token: \(accessToken.isEmpty ? "Null" : accessToken)")

        return request
    }

    private func validateResponse(_ response: URLResponse, data: Data?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            bnPrint("🚨 Invalid HTTP response")
            throw NetworkError.unknown
        }

        bnPrint("📥 Status Code: \(httpResponse.statusCode)")
        if let responseString = data?.prettyPrintedJSON {
            bnPrint("📦 Response:\n\(responseString)")
        }

        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            bnPrint("🚨 Unauthorized (401)")
            throw NetworkError.unauthorized
        case 403:
            bnPrint("🚨 Forbidden (403)")
            throw NetworkError.forbidden
        case 404:
            bnPrint("🚨 Not Found (404)")
            throw NetworkError.notFound
        case 400...499:
            bnPrint("🚨 Client Error (\(httpResponse.statusCode))")
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        case 500...599:
            bnPrint("🚨 Server Error (\(httpResponse.statusCode))")
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        default:
            bnPrint("🚨 Unknown status code: \(httpResponse.statusCode)")
            throw NetworkError.unknown
        }
    }
}
