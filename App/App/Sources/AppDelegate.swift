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
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        /// Load DesignSystem Resource
        BNFont.loadFonts()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return false
    }
}
