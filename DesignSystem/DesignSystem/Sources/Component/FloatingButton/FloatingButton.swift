//
//  FloatingButton.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import SwiftUI

public struct FloatingButton: View {
    @State private var state: FloatingButtonState = .close
    
    init(state: FloatingButtonState) {
        self.state = state
    }
    
    public var body: some View {
        ZStack {
            Color(state == .open ? BNColor(.type(.gray1000)).uiColor : .clear)
                .opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    self.state = .close
                }
                .animation(.linear(duration: 0.2), value: state)
            HStack {
                Spacer()
                VStack(
                    alignment: .trailing,
                    spacing: 10,
                ) {
                    Spacer()
                    if state == .open {
                        FloatingContextMenu(
                            menuButtons: [
                                FloatingContextMenuButton(
                                    icon: .vote,
                                    text: "투표 등록",
                                ) {
                                    // TODO: (종식, 20260128) - 작업 필요
                                },
                                FloatingContextMenuButton(
                                    icon: .product,
                                    text: "상품 리뷰",
                                ) {
                                    // TODO: (종식, 20260128) - 작업 필요
                                },
                            ]
                        )
                    }
                    FloatingCircleButton(
                        state: $state
                    )
                }
            }
            .padding(20)
        }
        
    }
}


#Preview {
    FloatingButton(state: .open)
}
