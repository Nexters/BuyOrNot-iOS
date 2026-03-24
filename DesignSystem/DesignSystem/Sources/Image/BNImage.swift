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
    
    func style(
        color: Color,
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
        color: Color,
        size: BNImageSize? = nil,
        contentMode: ContentMode = .fit
    ) -> some View {
        @ViewBuilder var image: some View {
            switch size {
            case .some(let size):
                self.resizable()
                    .aspectRatio(contentMode: contentMode)
                    .foregroundStyle(color)
                    .frame(width: size.width, height: size.height)
            case .none:
                self.aspectRatio(contentMode: contentMode)
                    .foregroundStyle(color)
            }
        }
        return image
    }
}

#Preview {
    VStack(spacing: 10) {
        BNImage(.notification)
            .style(
                color: ColorPalette.red100,
                size: 30,
            )
        BNImage(.product)
            .style(
                color: ColorPalette.blue100,
                size: 10
            )
        BNImage(.completed)
            .style(
                color: ColorPalette.gray800,
                size: 20
            )
    }
}
