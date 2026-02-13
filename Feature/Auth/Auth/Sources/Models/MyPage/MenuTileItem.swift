//
//  MenuTileItem.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import DesignSystem

protocol MenuTileItem {
    var title: String { get }
    var hasAction: Bool { get }
    var textColor: Color { get }
}

extension MenuTileItem {
    var hasAction: Bool {
        true
    }
    
    var textColor: Color {
        .type(.gray900)
    }
}
