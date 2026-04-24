//
//  FeedEndpoint.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

enum FeedEndpoint: Endpoint {
    case getFeeds(cursor: Int?, size: Int?, feedStatus: String?, category: String?)
    case getMyFeeds(cursor: Int?, size: Int?, feedStatus: String?, category: String?)
    case postFeeds(PostFeedRequest)
    case postVote(feedId: Int, body: PostVoteRequest)
    case postFeedsReport(Int)
    case deleteFeeds(Int)
    case getFeed(feedId: Int)

    var path: String {
        switch self {
        case .getMyFeeds:
            return version.path + "/users/me/feeds"
        default:
            let prefix = "/feeds"
            let path = switch self {
            case .getFeeds:
                ""
            case .postFeeds:
                ""
            case .postVote(let feedId, _):
                "/\(feedId)/votes"
            case .postFeedsReport(let feedId):
                "/\(feedId)/report"
            case .deleteFeeds(let feedId):
                "/\(feedId)"
            case .getFeed(let feedId):
                "/\(feedId)"
            case .getMyFeeds:
                ""
            }
            return version.path + prefix + path
        }
    }

    var version: APIVersion {
        switch self {
        case .getFeeds, .getMyFeeds, .getFeed, .postFeeds:
            return .v2
        default:
            return .v1
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFeeds, .getMyFeeds, .getFeed:
                .get
        case .postFeeds:
                .post
        case .postVote:
                .post
        case .postFeedsReport:
                .post
        case .deleteFeeds:
                .delete
        }
    }

    var queryParameters: [String: Any]? {
        switch self {
        case .getFeeds(let cursor, let size, let feedStatus, let category),
             .getMyFeeds(let cursor, let size, let feedStatus, let category):
            var params: [String: Any] = [:]
            if let cursor { params["cursor"] = cursor }
            if let size { params["size"] = size }
            if let feedStatus { params["feedStatus"] = feedStatus }
            if let category {
                params["category"] = category.components(separatedBy: ",")
            }
            return params.isEmpty ? nil : params
        default:
            return nil
        }
    }

    var body: (any Encodable)? {
        switch self {
        case .getFeeds, .getMyFeeds, .getFeed:
            nil
        case .postFeeds(let postFeedRequest):
            postFeedRequest
        case .postVote(_, let body):
            body
        case .postFeedsReport:
            nil
        case .deleteFeeds:
            nil
        }
    }
}
