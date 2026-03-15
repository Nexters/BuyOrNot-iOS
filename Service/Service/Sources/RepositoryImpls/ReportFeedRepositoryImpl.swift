//
//  ReportFeedRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 3/15/26.
//

import Domain

public final class ReportFeedRepositoryImpl: ReportFeedRepository {
    private let store: ReportFeedStore

    public init() {
        self.store = ReportFeedStore()
    }

    public func saveReportFeed(_ feed: ReportFeed) {
        store.saveReportFeed(feed)
    }

    public func getReportFeed() -> ReportFeed? {
        store.getReportFeed()
    }

    public func removeReportFeed() {
        store.removeReportFeed()
    }
}
