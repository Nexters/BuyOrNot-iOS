//
//  UIApplication+Extension.swift
//  Core
//
//  Created by 문종식 on 2/13/26.
//

import UIKit

public extension UIApplication {
    static var topViewController: UIViewController? {
        UIApplication.shared.getTopViewController()
    }
    
    private func getTopViewController(
        base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: { $0.isKeyWindow })?
            .rootViewController
    ) -> UIViewController? {
        if let navigationController = base as? UINavigationController {
            return getTopViewController(
                base: navigationController.visibleViewController
            )
        }
        
        if let tabBarController = base as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return getTopViewController(
                base: selectedViewController
            )
        }
        
        if let presentedViewController = base?.presentedViewController {
            return getTopViewController(
                base: presentedViewController
            )
        }
        
        return base
    }
}
