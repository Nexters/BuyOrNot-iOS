//
//  Data+Extension.swift
//  Core
//
//  Created by 문종식 on 2/20/26.
//

import Foundation

public extension Data {
    var toString: String? {
        guard let string = String(data: self, encoding: .utf8) else {
            return nil
        }
        guard !string.isEmpty else {
            return nil
        }
        return string
    }
    
    var prettyPrintedJSON: String? {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted, .sortedKeys]
            ),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return nil
        }
        return prettyString
    }
}
