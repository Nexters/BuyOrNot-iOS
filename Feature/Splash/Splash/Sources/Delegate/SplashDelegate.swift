//
//  SplashDelegate.swift
//  Splash
//
//  Created by 문종식 on 2/21/26.
//

import Domain

public protocol SplashDelegate {
    func completeSplash(_ result: AuthState)
}
