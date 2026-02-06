//
//  NetworkClient.swift
//  Service
//
//  Created by 이조은 on 2/7/26.
//

import Foundation

public protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws -> Void
}

public final class NetworkClient: NetworkClientProtocol {

    public static let shared = NetworkClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try buildRequest(from: endpoint)

        do {
            let (data, response) = try await session.data(for: request)

            try validateResponse(response, data: data)

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                #if DEBUG
                print("🚨 Decoding failed: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 Response data: \(jsonString)")
                }
                #endif
                throw NetworkError.decodingFailed(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            #if DEBUG
            print("🚨 Network request failed: \(error.localizedDescription)")
            #endif
            throw NetworkError.requestFailed(error)
        }
    }

    public func request(_ endpoint: Endpoint) async throws -> Void {
        let request = try buildRequest(from: endpoint)

        do {
            let (data, response) = try await session.data(for: request)

            try validateResponse(response, data: data)
        } catch let error as NetworkError {
            throw error
        } catch {
            #if DEBUG
            print("🚨 Network request failed: \(error.localizedDescription)")
            #endif
            throw NetworkError.requestFailed(error)
        }
    }

    // MARK: - Private Methods

    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {

        guard var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            #if DEBUG
            print("🚨 Invalid URL: \(endpoint.baseURL + endpoint.path)")
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
        print("🌐 [\(endpoint.method.rawValue)] \(url.absoluteString)")
        if let httpBody = request.httpBody,
           let bodyString = String(data: httpBody, encoding: .utf8) {
            print("📤 Request Body: \(bodyString)")
        }
        if let headers = endpoint.headers {
            print("📋 Custom Headers: \(headers)")
        }
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
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("📦 Response: \(responseString)")
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
