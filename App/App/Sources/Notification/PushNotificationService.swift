//
//  PushNotificationService.swift
//  App
//
//  Created by 이조은 on 2/25/26.
//

import Foundation
import UserNotifications
import UIKit
import FirebaseMessaging
import Domain

final class PushNotificationService {
    static let shared = PushNotificationService()

    private let notificationCenter = UNUserNotificationCenter.current()
    private let defaults = UserDefaults.standard
    private let hasRequestedKey = "HAS_REQUESTED_NOTIFICATION_PERMISSION"
    private let lastTokenKey = "LAST_FCM_TOKEN"

    private init() {}

    func requestAuthorizationIfNeeded() async {
        let settings = await notificationCenter.notificationSettings()
        let hasRequested = defaults.bool(forKey: hasRequestedKey)
        guard settings.authorizationStatus == .notDetermined, !hasRequested else { return }

        let granted = (try? await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])) ?? false
        defaults.set(true, forKey: hasRequestedKey)

        if granted {
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func syncFCMTokenIfPossible(userRepository: UserRepository?) async {
        #if DEBUG
        print("🔔 [PushNotificationService] syncFCMTokenIfPossible called")
        #endif
        guard let userRepository else { return }

        let settings = await notificationCenter.notificationSettings()
        let status = settings.authorizationStatus
        #if DEBUG
        print("🔔 [PushNotificationService] authorizationStatus: \(status.rawValue)")
        #endif
        guard status == .authorized || status == .provisional || status == .ephemeral else {
            #if DEBUG
            print("🔔 [PushNotificationService] authorization not granted. skip")
            #endif
            return
        }

        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }

        guard Messaging.messaging().apnsToken != nil else {
            #if DEBUG
            print("🔔 [PushNotificationService] APNS token not set yet. skip FCM token")
            #endif
            return
        }

        do {
            let token = try await Messaging.messaging().token()
            #if DEBUG
            print("🔔 [PushNotificationService] FCM token fetched: \(token)")
            #endif
            guard !token.isEmpty else { return }
            let lastToken = defaults.string(forKey: lastTokenKey)
            guard token != lastToken else { return }

            try await userRepository.updateFCMToken(token)
            defaults.set(token, forKey: lastTokenKey)
            #if DEBUG
            print("✅ [PushNotificationService] FCM token synced to server")
            #endif
        } catch {
            #if DEBUG
            print("❌ [PushNotificationService] sync failed: \(error)")
            #endif
            // Intentionally ignore to avoid blocking UI flow
        }
    }
}
