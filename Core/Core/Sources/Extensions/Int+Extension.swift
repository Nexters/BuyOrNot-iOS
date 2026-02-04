//
//  Int+Extension.swift
//  Core
//
//  Created by 문종식 on 2/3/26.
//

import Foundation

public extension Int {
    /*
     * 문자열을 화폐단위 형식으로 변환합니다.
     * 변환에 실패할 경우 빈 문자열을 반환합니다.
     */
    var toCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(for: self) ?? "\(self)"
    }
}
