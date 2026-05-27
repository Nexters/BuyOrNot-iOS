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
    private let onDone: (Int) -> Void
    private let onCrop: () -> Void
    private let onRotate: () -> Void
    @State private var rotationQuarterTurns: Int = 0

    public init(
        image: Image = Image(systemName: "photo"),
        onBack: @escaping () -> Void = {},
        onDone: @escaping (Int) -> Void = { _ in },
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

            Button {
                onDone(rotationQuarterTurns)
            } label: {
                BNText("완료")
                    .style(style: .s3sb, color: ColorPalette.gray0)
                    .padding(10)
            }
            .padding(.trailing, 10)
        }
    }

    private var imageArea: some View {
        GeometryReader { proxy in
            let size = proxy.size
            image
                .resizable()
                .scaledToFit()
                .frame(
                    width: isRightAngleRotation ? size.height : size.width,
                    height: isRightAngleRotation ? size.width : size.height
                )
                .rotationEffect(rotationAngle)
                .frame(width: size.width, height: size.height)
        }
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
                action: rotateLeft
            )
            Spacer()
        }
        .padding(20)
    }

    private var rotationAngle: Angle {
        .degrees(Double(rotationQuarterTurns * -90))
    }

    private var isRightAngleRotation: Bool {
        rotationQuarterTurns % 2 != 0
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

    private func rotateLeft() {
        withAnimation(.easeInOut(duration: 0.2)) {
            rotationQuarterTurns += 1
        }
        onRotate()
    }
}
