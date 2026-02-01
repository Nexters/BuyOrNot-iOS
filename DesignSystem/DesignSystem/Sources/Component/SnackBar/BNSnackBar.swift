//
//  BNSnackBar.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import SwiftUI

public struct BNSnackBar: View {
    private let item: BNSnackBarItem
    private var backgroundColor: Color {
        BNColor(.type(.gray900)).color
    }
    
    @State var opacity: Double = 0
    
    init(item: BNSnackBarItem) {
        self.item = item
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            if let iconConfig = item.iconConfig {
                BNImage(iconConfig.icon)
                    .style(
                        color: iconConfig.color,
                        size: iconConfig.size
                    )
            }
            BNText(item.text)
                .style(
                    style: .b5m,
                    color: .type(.gray50)
                )
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background {
            RoundedRectangle(
                cornerRadius: 10
            )
            .fill(backgroundColor)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        VStack {
            Spacer()
            BNSnackBar(
                item: BNSnackBarItem(
                    text: "스낵바입니다. 안내 메세지를 작성해주세요.",
                    iconConfig: .init(
                        icon: .completed,
                        color: .type(.green200),
                        size: 16
                    )
                )
            )
        }

    }
}
