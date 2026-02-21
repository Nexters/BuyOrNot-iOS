//
//  BaseResponse.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

struct BaseResponse<T: Decodable>: Decodable {
    public let data: T
    public let message: String
    public let status: String
    public let errorCode: String?
}
