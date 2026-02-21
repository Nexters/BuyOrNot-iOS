//
//  FeedEndpoint.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

enum FeedEndpoint: Endpoint {
    case getFeeds
    case postFeeds(PostFeedRequest)
    case postFeedsReport(Int)
    case deleteFeeds(Int)
    
    var path: String {
        let prefix = "/feeds"
        let path = switch self {
        case .getFeeds:
            ""
        case .postFeeds:
            ""
        case .postFeedsReport(let feedId):
            "/\(feedId)/report"
        case .deleteFeeds(let feedId):
            "/\(feedId)"
        }
        return version.path + prefix + path
    }
    
    var method: HTTPMethod {
        switch self {
        case .getFeeds:
                .get
        case .postFeeds:
                .post
        case .postFeedsReport:
                .post
        case .deleteFeeds:
                .delete
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .getFeeds:
            nil
        case .postFeeds(let postFeedRequest):
            postFeedRequest
        case .postFeedsReport:
            nil
        case .deleteFeeds:
            nil
        }
    }
}
