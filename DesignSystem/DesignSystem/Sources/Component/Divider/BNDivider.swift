//
//  Divider.swift
//  DesignSystem
//
//  Created by 문종식 on 2/2/26.
//

import SwiftUI

public struct BNDivider: View {
    let size: BNDividerSize
    
    public init(size: BNDividerSize) {
        self.size = size
    }
    
    public var body: some View {
        Rectangle()
            .fill(.bnType(.gray100))
            .frame(height: size.height)
    }
}

#Preview {
    ZStack {
        Color.bnType(.gray700)
        VStack(spacing: 20) {
            BNDivider(size: .l)
            BNDivider(size: .s)
        }
    }
}
