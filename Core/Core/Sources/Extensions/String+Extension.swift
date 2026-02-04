//
//  String+Extension.swift
//  Core
//
//  Created by 문종식 on 2/3/26.
//

import Foundation

public extension String {
    /*
     * 문자열을 화폐단위 형식으로 변환합니다.
     * 숫자 변환에 실패할 경우 빈 문자열을 반환합니다.
     */
    var toCurrency: String {
        guard let num = Int(self) else {
            return ""
        }
        return num.toCurrency
    }
    
    var isInt: Bool {
        let valueWithoutComma = self.replacingOccurrences(of: ",", with: "")
        return Int(valueWithoutComma) != nil
    }
    
    var toInt: Int? {
        let valueWithoutComma = self.replacingOccurrences(of: ",", with: "")
        return Int(valueWithoutComma)
    }
}
