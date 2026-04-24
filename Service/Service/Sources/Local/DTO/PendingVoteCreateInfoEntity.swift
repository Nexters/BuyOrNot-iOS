//
//  PendingVoteCreateInfoEntity.swift
//  Service
//
//  Created by 문종식 on 3/15/26.
//

struct PendingVoteCreateInfoEntity: Codable {
    let category: String?
    let linkURL: String?
    let title: String?
    let price: String
    let content: String

    init(category: String?, linkURL: String?, title: String?, price: String, content: String) {
        self.category = category
        self.linkURL = linkURL
        self.title = title
        self.price = price
        self.content = content
    }
}
