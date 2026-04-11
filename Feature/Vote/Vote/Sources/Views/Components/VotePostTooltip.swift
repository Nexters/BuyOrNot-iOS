//
//  VotePostTooltip.swift
//  Vote
//
//  Created by 문종식 on 4/11/26.
//

import SwiftUI
import DesignSystem

struct VotePostTooltip: View {
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 4) {
                BNImage(.clock)
                    .style(color: ColorPalette.gray700, size: 16)
                
                BNText("투표는 48시간동안 진행돼요.")
                    .style(style: .p4m, color: ColorPalette.gray700)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(ColorPalette.gray0)
            )
            
            VotePostTooltipTrail()
                .fill(ColorPalette.gray0)
                .frame(width: 5, height: 10)
        }
        .shadow(
            color: ColorPalette
                .fromHex("#3670DB")
                .opacity(0.2),
            radius: 25,
            x: 40,
            y: 4
        )
    }
}

private struct VotePostTooltipTrail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        path.closeSubpath()
        return path
    }
}
