//
//  FloatingContextMenu.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import SwiftUI

public struct FloatingContextMenu: View {
    public init(menuButtons: [FloatingContextMenuButton]) {
        self.menuButtons = menuButtons
    }
    
    private let menuButtons: [FloatingContextMenuButton]
    
    public var body: some View {
        VStack(spacing: 4) {
            ForEach(menuButtons.indices, id: \.self) { i in
                menuButtons[i]
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorPalette.gray0)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            ColorPalette.gray100,
                            lineWidth: 1
                        )
                )
        }
    }
}
