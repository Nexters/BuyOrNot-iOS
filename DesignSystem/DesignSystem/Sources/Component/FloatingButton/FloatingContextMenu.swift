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
        VStack(spacing: 0) {
            ForEach(menuButtons.indices, id: \.self) { i in
                menuButtons[i]
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(.gray0)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            .type(.gray100),
                            lineWidth: 1
                        )
                )
        }
    }
}
