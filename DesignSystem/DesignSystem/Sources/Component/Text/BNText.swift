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
            .style(.d1b, .type(.green200))
        BNText("Heading3 Red100")
            .style(.h3b, .type(.red100))
        BNText("Boby1 Color.yellow")
            .style(.b1m, .color(.yellow))
        BNText("Boby4 Gray600")
            .style(.b4m, .type(.gray600))
        BNText("Paragraph Medium2 Blue100")
            .style(.p2m, .type(.blue100))
    }
}
