//
//  FloatingPrimaryButton.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

struct FloatingCircleButton: View {
    @Binding var state: FloatingButtonState
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    BNColor(state == .open ? .gray0 : .gray800).color
                )
                .shadow(
                    color: state == .close ? BNColor(hex: "#313540").color.opacity(0.2) : .clear,
                    radius: state == .close ? 30 : 0,
                    x: 0,
                    y: state == .close ? 6 : 0
                )
            
            ZStack {
                BNImage(.plus)
                    .image
                    .rotationEffect(.degrees(state == .open ? -45 : 0))
                    .opacity(state == .open ? 0 : 1)
                
                BNImage(.close)
                    .image
                    .rotationEffect(.degrees(state == .open ? 0 : 45))
                    .opacity(state == .open ? 1 : 0)
            }
            .foregroundStyle(
                BNColor(state == .open ? .gray800 : .gray0).color
            )
            .animation(.linear(duration: 0.2), value: state)
        }
        .frame(width: 60, height: 60)
        .onTapGesture {
            switch (state) {
            case .open:
                state = .close
            case .close:
                state = .open
            }
        }
    }
}
