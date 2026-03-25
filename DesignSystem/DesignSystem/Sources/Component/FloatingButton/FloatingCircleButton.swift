//
//  FloatingCircleButton.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

struct FloatingCircleButton: View {
    private let iconSize: CGFloat = 24
    private let buttonSize: CGFloat = 60
    
    @Binding var state: FloatingButtonState
    
    // TODO: 투표 등록 외 다른 메뉴 추가전까지 사용 (26.03.25) - 종식
    let onVoteCreate: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .fill(state == .open ? ColorPalette.gray0 : ColorPalette.gray800)
                .shadow(
                    color: state == .close ? ColorPalette.fromHex("#313540").opacity(0.2) : .clear,
                    radius: state == .close ? 30 : 0,
                    x: 0,
                    y: state == .close ? 6 : 0
                )
            
            ZStack {
                BNImage(.plus)
                    .style(
                        color: ColorPalette.gray0,
                        size: iconSize
                    )
                    .rotationEffect(.degrees(state == .open ? -45 : 0))
                    .opacity(state == .open ? 0 : 1)
                
                BNImage(.close)
                    .style(
                        color: ColorPalette.gray800,
                        size: iconSize
                    )
                    .rotationEffect(.degrees(state == .open ? 0 : 45))
                    .opacity(state == .open ? 1 : 0)
            }
            .animation(.linear(duration: 0.2), value: state)
        }
        .frame(width: buttonSize, height: buttonSize)
        .onTapGesture {
//            switch (state) {
//            case .open:
//                state = .close
//            case .close:
//                state = .open
//            }
            // TODO: 투표 등록 외 다른 메뉴 추가전까지 사용 (26.03.25) - 종식
            onVoteCreate()
        }
    }
}
