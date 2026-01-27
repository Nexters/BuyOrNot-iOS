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
    
    let icon: BNImageAsset
    let text: String
    let action: () -> Void
    
    @State var isPressing: Bool = false
    
    public var body: some View {
        HStack(spacing: 6) {
            BNImage(icon)
                .image
                .frame(width: 14, height: 14)
            Text(text)
                .font(BNFont.font(.b3m))
        }
        .foregroundStyle(BNColor(.gray800).color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    BNColor(isPressing ? .gray200 : .gray0).color
                )
        }
        .onLongPressGesture(
            minimumDuration: .infinity,
            perform: {}
        ) { isPressing in
            self.isPressing = isPressing
        }
    }
}
