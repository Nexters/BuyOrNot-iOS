//
//  AuthResponse.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let user: UserResponse
}
