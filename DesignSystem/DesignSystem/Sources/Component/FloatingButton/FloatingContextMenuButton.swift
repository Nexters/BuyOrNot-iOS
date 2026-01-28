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
                .style(.type(.gray800), BNImageSize(14), .fit)
            BNText(text)
                .style(.b3m, .type(.gray800))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    BNColor(.type(isPressing ? .gray200 : .gray0)).color
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
