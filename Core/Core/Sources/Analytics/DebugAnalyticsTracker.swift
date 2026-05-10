import Foundation
import Mixpanel

public final class DebugAnalyticsTracker: AnalyticsTracking {
    public init() {}

    public func track(name: String, properties: AnalyticsProperties) {}

    public func setUserId(_ userId: String?) {}
}
