//
//  Bundle+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 1/21/26.
//

import Foundation

private class DesignSystemBundle { }
private let designSystemBundleIdentifier: String = Bundle(for: DesignSystemBundle.self).bundleIdentifier ?? "com.sseotdabwa.buyornot.designsystem"

public extension Bundle {
    static var designSystem: Bundle  {
        Bundle(identifier: designSystemBundleIdentifier) ?? .main
    }
}
