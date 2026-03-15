//
//  ReportFeedRepository.swift
//  Domain
//
//  Created by 문종식 on 3/15/26.
//

public protocol ReportFeedRepository {
    func saveReportFeed(_ feed: ReportFeed)
    func getReportFeed() -> ReportFeed?
    func removeReportFeed()
}
