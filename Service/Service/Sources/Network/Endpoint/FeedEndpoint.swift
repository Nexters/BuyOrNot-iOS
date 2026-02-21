//
//  FeedEndpoint.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

enum FeedEndpoint: Endpoint {
    case getFeeds(cursor: Int?, size: Int?, feedStatus: String?)
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

    var queryParameters: [String: Any]? {
        switch self {
        case .getFeeds(let cursor, let size, let feedStatus):
            var params: [String: Any] = [:]
            if let cursor { params["cursor"] = cursor }
            if let size { params["size"] = size }
            if let feedStatus { params["feedStatus"] = feedStatus }
            return params.isEmpty ? nil : params
        default:
            return nil
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
