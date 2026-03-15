//
//  ReportFeed.swift
//  Domain
//
//  Created by 문종식 on 3/15/26.
//

public struct ReportFeed: Equatable {
    public let ids: Set<String>

    public init(ids: Set<String>) {
        self.ids = ids
    }
}
