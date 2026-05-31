//
//  BNPrint.swift
//  Core
//
//  Created by 문종식 on 5/31/26.
//

import Foundation

public func bnPrint(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n"
) {
#if DEBUG
    let message = items.map { String(describing: $0) }.joined(separator: separator)
    print(message, terminator: terminator)
#endif
}
