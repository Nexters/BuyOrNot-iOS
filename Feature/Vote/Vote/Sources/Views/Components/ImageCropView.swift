//
//  ImageCropView.swift
//  Vote
//
//  Created by 문종식 on 5/27/26.
//

import SwiftUI
import DesignSystem

public struct ImageCropView: View {
    private let image: Image
    private let onBack: () -> Void
    private let onDone: () -> Void
    private let onCrop: () -> Void
    private let onRotate: () -> Void

    public init(
        image: Image = Image(systemName: "photo"),
        onBack: @escaping () -> Void = {},
        onDone: @escaping () -> Void = {},
        onCrop: @escaping () -> Void = {},
        onRotate: @escaping () -> Void = {}
    ) {
        self.image = image
        self.onBack = onBack
        self.onDone = onDone
        self.onCrop = onCrop
        self.onRotate = onRotate
    }

    public var body: some View {
        ZStack {
            ColorPalette.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                navigationBar
                Spacer(minLength: 0)
                imageArea
                Spacer(minLength: 0)
                bottomBar
            }
            .padding(.vertical, 6)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }

    private var navigationBar: some View {
        HStack(spacing: 0) {
            Button(action: onBack) {
                BNImage(.left)
                    .style(color: ColorPalette.gray0, size: 20)
                    .padding(10)
                    .frame(width: 40, height: 40)
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)

            Spacer(minLength: 0)

            Button(action: onDone) {
                BNText("완료")
                    .style(style: .s3sb, color: ColorPalette.gray0)
                    .padding(10)
            }
            .padding(.trailing, 10)
        }
    }

    private var imageArea: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var bottomBar: some View {
        HStack(spacing: 20) {
            Spacer()
            actionButton(
                imageAsset: .crop,
                title: "자르기",
                action: onCrop
            )
            actionButton(
                imageAsset: .rotate_left,
                title: "회전",
                action: onRotate
            )
            Spacer()
        }
        .padding(20)
    }

    private func actionButton(
        imageAsset: BNImageAsset,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                BNImage(imageAsset)
                    .style(color: ColorPalette.gray0, size: 18)
                BNText(title)
                    .style(style: .s3sb, color: ColorPalette.gray0)
            }
        }
    }
}
