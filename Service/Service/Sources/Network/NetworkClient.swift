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
                #if DEBUG
                print("🚨 Decoding failed: \(error)")
                if let jsonString = data.prettyPrintedJSON {
                    print("📦 Response data:\n\(jsonString)")
                }
                #endif
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
            #if DEBUG
            print("🚨 Network request failed: \(error.localizedDescription)")
            #endif
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
            #if DEBUG
            print("🚨 Network request failed: \(error.localizedDescription)")
            #endif
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
            #if DEBUG
            print("🚨 Invalid Base URL: baseURL is null")
            #endif
            throw NetworkError.invalidBaseURL
        }
        
        guard var urlComponents = URLComponents(string: baseURL + endpoint.path) else {
            #if DEBUG
            print("🚨 Invalid URL: \(baseURL + endpoint.path)")
            #endif
            throw NetworkError.invalidURL
        }

        if let queryParameters = endpoint.queryParameters {
            urlComponents.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        guard let url = urlComponents.url else {
            #if DEBUG
            print("🚨 Failed to create URL from components")
            #endif
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
                #if DEBUG
                print("🚨 Encoding failed: \(error)")
                #endif
                throw NetworkError.encodingFailed
            }
        }

        #if DEBUG
        print("\n🌐 [\(endpoint.method.rawValue)] \(url.absoluteString)")
        if let httpBody = request.httpBody,
           let bodyString = String(data: httpBody, encoding: .utf8) {
            print("📤 Request Body: \(bodyString)")
        }
        if let headers = endpoint.headers {
            print("📋 Custom Headers: \(headers)")
        }
        print("🔑 Bearer Token: \(accessToken.isEmpty ? "Null" : accessToken)")
        #endif

        return request
    }

    private func validateResponse(_ response: URLResponse, data: Data?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            #if DEBUG
            print("🚨 Invalid HTTP response")
            #endif
            throw NetworkError.unknown
        }

        #if DEBUG
        print("📥 Status Code: \(httpResponse.statusCode)")
        if let responseString = data?.prettyPrintedJSON {
            print("📦 Response:\n\(responseString)")
        }
        #endif

        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            #if DEBUG
            print("🚨 Unauthorized (401)")
            #endif
            throw NetworkError.unauthorized
        case 403:
            #if DEBUG
            print("🚨 Forbidden (403)")
            #endif
            throw NetworkError.forbidden
        case 404:
            #if DEBUG
            print("🚨 Not Found (404)")
            #endif
            throw NetworkError.notFound
        case 400...499:
            #if DEBUG
            print("🚨 Client Error (\(httpResponse.statusCode))")
            #endif
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        case 500...599:
            #if DEBUG
            print("🚨 Server Error (\(httpResponse.statusCode))")
            #endif
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        default:
            #if DEBUG
            print("🚨 Unknown status code: \(httpResponse.statusCode)")
            #endif
            throw NetworkError.unknown
        }
    }
}
