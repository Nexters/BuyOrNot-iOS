//
//  BNImage.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import SwiftUI

typealias BNImage = Image

public extension BNImage {
    init(_ asset: BNImageAsset) {
        self = Image(asset.rawValue, bundle: .module)
    }
    
    /// BNImage 전용 Style Modifier  - 정방향
    func style(
        _ color: BNColor.Source,
        _ size: CGFloat,
        _ contentMode: ContentMode
    ) -> some View {
        self.style(color, BNImageSize(size), contentMode)
    }
    
    /// BNImage 전용 Style Modifier
    func style(
        _ color: BNColor.Source,
        _ size: BNImageSize? = nil,
        _ contentMode: ContentMode
    ) -> some View {
        @ViewBuilder var image: some View {
            switch size {
            case .some(let size):
                self.resizable()
                    .aspectRatio(contentMode: contentMode)
                    .foregroundStyle(BNColor(color).color)
                    .frame(width: size.width, height: size.height)
            case .none:
                self.aspectRatio(contentMode: contentMode)
                    .foregroundStyle(BNColor(color).color)
            }
        }
        return image
    }
}

#Preview {
    VStack(spacing: 10) {
        BNImage(.notification)
            .style(.type(.red100), 30, .fit)
        BNImage(.product)
            .style(.type(.blue100), 10, .fit)
        BNImage(.completed)
            .style(.type(.gray800), 20, .fit)
    }
}

