//
//  FloatingContextMenu.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import SwiftUI

public struct FloatingContextMenu: View {
    init(menuButtons: [FloatingContextMenuButton]) {
        self.menuButtons = menuButtons
    }
    
    let menuButtons: [FloatingContextMenuButton]
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(menuButtons.indices, id: \.self) { i in
                menuButtons[i]
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(BNColor(.type(.gray0)).color)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(BNColor(.type(.gray100)).color, lineWidth: 1)
                )
        }
    }
}
