import Foundation

public protocol AnalyticsTracking {
    func track(name: String, properties: [String: Any])
    func setUserId(_ userId: String?)
}
