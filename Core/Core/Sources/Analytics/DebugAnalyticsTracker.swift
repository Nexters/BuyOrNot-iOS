import Foundation

public final class DebugAnalyticsTracker: AnalyticsTracking {
    public init() {}

    public func track(name: String, properties: [String: Any]) {}

    public func setUserId(_ userId: String?) {}
}
