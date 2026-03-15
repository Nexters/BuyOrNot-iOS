//
//  PendingVoteCreateInfoEntity.swift
//  Service
//
//  Created by 문종식 on 3/15/26.
//

struct PendingVoteCreateInfoEntity: Codable {
    let category: String?
    let price: String
    let content: String

    init(category: String?, price: String, content: String) {
        self.category = category
        self.price = price
        self.content = content
    }
}
