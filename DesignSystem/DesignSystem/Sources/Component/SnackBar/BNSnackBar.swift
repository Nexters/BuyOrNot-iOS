//
//  BNSnackBar.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import SwiftUI

public struct BNSnackBar: View {
    private let item: BNSnackBarItem
    private let iconSize: CGFloat = 16
    private var backgroundColor: Color {
        BNColor(.type(.gray900)).color
    }
    
    @State var opacity: Double = 0
    @Binding var state: BNSnackBarState
    
    public init(
        item: BNSnackBarItem,
        state: Binding<BNSnackBarState>
    ) {
        self.item = item
        self._state = state
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            if let iconConfig = item.iconConfig {
                BNImage(iconConfig.icon)
                    .style(
                        color: iconConfig.color,
                        size: iconSize
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
        .offset(y: state.offsetY)
        .opacity(state.opacity)
        .animation(
            .linear(duration: 0.3),
            value: state
        )
    }
}


private struct BNSnackBarPreview: View {
    @State private var manager = BNSnackBarManager()
    @State private var count = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Button {
                    let item = BNSnackBarItem(
                        text: "스낵바입니다. 안내 메세지를 작성해주세요. \(count)",
                        icon: .completed,
                        color: .type(.green200),
                    )
                    count += 1
                    manager.addItem(item)
                } label: {
                    Text("SnackBarItem 추가")
                }
                
                Button {
                    let item = BNSnackBarItem(
                        text: "신고가 완료되었습니다.",
                        icon: .completed,
                        color: .type(.red100),
                    )
                    count += 1
                    manager.addItem(item)
                } label: {
                    Text("게시글 신고")
                }
                
                Button {
                    let item = BNSnackBarItem(
                        text: "삭제가 완료되었습니다.",
                        icon: .completed,
                        color: .type(.green100),
                    )
                    count += 1
                    manager.addItem(item)
                } label: {
                    Text("게시글 삭제")
                }
                Text("Count: \(count)")
            }
            
            VStack {
                Spacer()
                BNSnackBar(
                    item: manager.currentItem,
                    state: $manager.barState
                )
            }
        }
    }
}

#Preview {
    BNSnackBarPreview()
}

