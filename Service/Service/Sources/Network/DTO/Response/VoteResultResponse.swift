//
//  VoteResultResponse.swift
//  Service
//
//  Created by 이조은 on 2/21/26.
//

import Foundation

struct VoteResultResponse: Decodable {
    let feedId: Int
    let choice: String
    let yesCount: Int
    let noCount: Int
    let totalCount: Int
}
