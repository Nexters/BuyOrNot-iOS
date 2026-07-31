//
//  AppDelegate.swift
//  App
//
//  Created by 문종식 on 2/3/26.
//

import UIKit
import DesignSystem
import Core
import Domain
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import FirebaseRemoteConfig

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    private let container = DIContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        /// Load DesignSystem Resource
        BNFont.loadFonts()
        
        setupRemoteConfig()
        setupAnalytics()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // 백그라운드에서 원격 알림 payload를 수신했을 때 추가 처리를 수행합니다.
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        let payload = RemotePushPayload(userInfo: userInfo)
        NotificationCenter.default.post(
            name: .didReceiveRemotePushPayload,
            object: nil,
            userInfo: [
                "notification": payload.notification,
                "data": payload.data
            ]
        )
        completionHandler(payload.data.isEmpty ? .noData : .newData)
    }
}
    
// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 실행 중일 때 도착한 알림의 표시 방식과 수신 처리를 결정합니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let payload = RemotePushPayload(
            userInfo: notification.request.content.userInfo
        )
        print("foreground push notification:", payload.notification)
        print("foreground push data:", payload.data)
        return [.banner, .sound, .badge]
    }

    // 사용자가 알림을 탭해 앱과 상호작용했을 때 payload를 처리합니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let payload = RemotePushPayload(
            userInfo: response.notification.request.content.userInfo
        )
        print("push tap notification:", payload.notification)
        print("push tap data:", payload.data)
    }
}

// MARK: - MessagingDelegate
extension AppDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken, !fcmToken.isEmpty else { return }
        Task {
            let userRepository: UserRepository = container.resolve()
            await PushNotificationService.shared.syncFCMTokenIfPossible(
                userRepository: userRepository
            )
        }
    }
}

// MARK: - RemoteConfig
extension AppDelegate {
    private func setupRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
    }
}

// MARK: - MixPanel
extension AppDelegate {
    private func setupAnalytics() {
#if DEBUG
        AnalyticsCenter.tracker = DebugAnalyticsTracker()
#else
        let token = Constants.getValue(with: .mixpanelToken)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        AnalyticsCenter.tracker = MixpanelAnalyticsTracker(token: token, appVersion: appVersion)
#endif
        AnalyticsCenter.tracker.setUserId(cachedUserIdString())
    }

    private func cachedUserIdString() -> String? {
        let userDefaults = UserDefaults(suiteName: "com.buyornot.app") ?? .standard
        guard let data = userDefaults.data(forKey: "USER"),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let id = json["id"] as? Int else {
            return nil
        }
        return String(id)
    }
}

private struct RemotePushPayload {
    let notification: [String: String]
    let data: [AnyHashable: Any]

    init(userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any] {
            notification = [
                "title": alert["title"] as? String ?? "",
                "body": alert["body"] as? String ?? ""
            ]
        } else {
            notification = [:]
        }

        data = userInfo.filter { key, _ in
            guard let key = key as? String else { return false }
            if key == "aps" { return false }
            if key.hasPrefix("gcm.") { return false }
            if key.hasPrefix("google.") { return false }
            return true
        }
    }
}
