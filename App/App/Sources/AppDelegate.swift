//
//  AppDelegate.swift
//  App
//
//  Created by 문종식 on 2/3/26.
//

import UIKit
import DesignSystem
import Auth

class AppDelegate: NSObject, UIApplicationDelegate {
    let auth = Auth()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Load DesignSystem Resource
        BNFont.loadFonts()
        auth.initAuth()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let result = auth.open(url: url) {
            return result
        }
        
        return false
    }
}
