//
//  Bundle+Extension.swift
//  Core
//
//  Created by 문종식 on 4/5/26.
//

import Foundation

public extension Bundle {
    var appVersionString: String {
        (infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0.0"
    }
}
