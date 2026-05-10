import Foundation
import Mixpanel

public final class MixpanelAnalyticsTracker: AnalyticsTracking {
    private let instance: MixpanelInstance

    public init(token: String, appVersion: String) {
        Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        self.instance = Mixpanel.mainInstance()
        instance.registerSuperProperties([
            "platform": "ios",
            "app_version": appVersion,
        ])
        observeUserIdChanges()
    }

    public func track(name: String, properties: [String: Any]) {
        instance.track(event: name, properties: properties)
    }

    public func setUserId(_ userId: String?) {
        if let userId {
            instance.registerSuperProperties(["user_id": userId])
        } else {
            instance.unregisterSuperProperty("user_id")
        }
    }

    private func observeUserIdChanges() {
        NotificationCenter.default.addObserver(
            forName: .analyticsUserIdDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            let userId = notification.object as? String
            self?.setUserId(userId)
        }
    }
}
