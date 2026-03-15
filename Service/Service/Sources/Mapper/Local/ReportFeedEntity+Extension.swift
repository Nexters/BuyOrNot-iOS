//
//  ReportFeedEntity+Extension.swift
//  Service
//
//  Created by 문종식 on 3/15/26.
//

import Domain

extension ReportFeedEntity {
    func toDomain() -> ReportFeed {
        ReportFeed(ids: ids)
    }
}
