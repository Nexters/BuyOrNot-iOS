//
//  FloatingContextMenuButton.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

public struct FloatingContextMenuButton: View {
    
    init(
        icon: BNImageAsset,
        text: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.text = text
        self.action = action
    }
    
    private let icon: BNImageAsset
    private let text: String
    private let action: () -> Void
    
    @State private var isPressing: Bool = false
    
    private var backgroundColor: Color {
        .bnType(isPressing ? .gray200 : .gray0)
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            BNImage(icon)
                .style(
                    color: .type(.gray800),
                    size: 14,
                )
            BNText(text)
                .style(
                    style: .b3m,
                    color: .type(.gray800)
                )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
        }
        .onTapGesture {
            action()
        }
        .onLongPressGesture(
            minimumDuration: .infinity,
            perform: {}
        ) { isPressing in
            self.isPressing = isPressing
        }
    }
}
