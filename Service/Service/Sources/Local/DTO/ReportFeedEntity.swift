//
//  ReportFeedEntity.swift
//  Service
//
//  Created by 문종식 on 3/15/26.
//

struct ReportFeedEntity: Codable {
    let ids: Set<String>

    init(ids: Set<String>) {
        self.ids = ids
    }
}
