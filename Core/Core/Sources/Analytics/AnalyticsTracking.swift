import Foundation
import Mixpanel

public typealias AnalyticsProperties = Properties

public protocol AnalyticsTracking {
    func track(name: String, properties: AnalyticsProperties)
    func setUserId(_ userId: String?)
}
