//
//  BNImage.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import SwiftUI

public typealias BNImage = Image

public extension BNImage {
    init(_ asset: BNImageAsset) {
        self = Image(asset.rawValue, bundle: .module)
    }
    
    /// BNImage 전용 Style Modifier  - 정방향
    func style(
        color: BNColor.Source,
        size: CGFloat,
        contentMode: ContentMode = .fit
    ) -> some View {
        self.style(
            color: color,
            size: BNImageSize(size),
            contentMode: contentMode
        )
    }
    
    /// BNImage 전용 Style Modifier
    func style(
        color: BNColor.Source,
        size: BNImageSize? = nil,
        contentMode: ContentMode = .fit
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
            .style(
                color: .type(.red100),
                size: 30,
            )
        BNImage(.product)
            .style(
                color: .type(.blue100),
                size: 10
            )
        BNImage(.completed)
            .style(
                color: .type(.gray800),
                size: 20
            )
    }
}

