//
//  LinkValidator.swift
//  Core
//
//  Created by 문종식 on 4/12/26.
//

import Foundation

public struct LinkValidator {
    private static let urlRegexPattern = #"^(https?:\/\/)(?=.{1,2048}$)(?!.*\s)(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}(?::\d{1,5})?(?:\/[A-Za-z0-9\-._~%!$&'()*+,;=:@/]*)?(?:\?[A-Za-z0-9\-._~%!$&'()*+,;=:@/?]*)?(?:#[A-Za-z0-9\-._~%!$&'()*+,;=:@/?]*)?$"#

    public init() {}

    public static func isValid(_ link: String) -> Bool {
        if link.isEmpty {
            return true
        }
        let result = link.range(of: urlRegexPattern, options: .regularExpression)
        return result != nil
    }
}
