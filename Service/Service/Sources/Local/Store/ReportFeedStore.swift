//
//  ReportFeedStore.swift
//  Service
//
//  Created by 문종식 on 3/15/26.
//

import Domain

final class ReportFeedStore: EntityStore {
    let client: UserDefaultsClientProtocol
    let key: UserDefaultsKey = .reportFeed

    init() {
        self.client = UserDefaultsClient()
    }

    func saveReportFeed(_ feed: ReportFeed) {
        let entity = ReportFeedEntity(ids: feed.ids)
        client.set(entity, for: key)
    }

    func getReportFeed() -> ReportFeed? {
        let entity: ReportFeedEntity? = client.get(for: key)
        return entity?.toDomain()
    }

    func removeReportFeed() {
        client.remove(for: key)
    }
}
