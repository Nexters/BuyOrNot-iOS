//
//  BNText.swift
//  DesignSystem
//
//  Created by 문종식 on 1/28/26.
//

import SwiftUI

public struct BNText: View {
    let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: Text {
        Text(text)
    }
}

#Preview {
    VStack(spacing: 10) {
        BNText("without Style")
        BNText("Display1 Green200")
            .style(
                style: .d1b,
                color: .type(.green200)
            )
        BNText("Heading3 Red100")
            .style(
                style: .h3b,
                color: .type(.red100)
            )
        BNText("Body1 Color.yellow")
            .style(
                style: .b1m,
                color: .yellow
            )
        BNText("Body4 Gray600")
            .style(
                style: .b4m,
                color: .type(.gray600)
            )
        BNText("Paragraph Medium2 Blue100")
            .style(
                style: .p2m,
                color: .type(.blue100)
            )
    }
}
