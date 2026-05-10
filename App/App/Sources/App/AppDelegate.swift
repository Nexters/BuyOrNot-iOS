//
//  AppDelegate.swift
//  App
//
//  Created by 문종식 on 2/3/26.
//

import UIKit
import DesignSystem
import Core
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import FirebaseRemoteConfig

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
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
}

extension AppDelegate {
    private func setupRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
    }

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
