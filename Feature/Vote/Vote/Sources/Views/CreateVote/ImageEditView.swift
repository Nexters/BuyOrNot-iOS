//
//  ImageEditView.swift
//  Vote
//
//  Created by 문종식 on 5/27/26.
//

import SwiftUI
import DesignSystem

public struct ImageEditView: View {
    private let image: Image
    private let onBack: () -> Void
    private let onDone: (Int) -> Void
    private let onCrop: () -> Void
    private let onRotate: () -> Void
    @State private var imageEditMode: ImageEditMode = .edit
    @State private var rotationQuarterTurns: Int = 0
    @State private var selectedImageCropMode: ImageCropMode = .free

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
                if imageEditMode == .crop {
                    cropBottomBar
                } else {
                    bottomBar
                }
            }
            .padding(.vertical, 6)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }

    private var navigationBar: some View {
        HStack(spacing: 0) {
            Button(action: handleBackButtonTap) {
                BNImage(imageEditMode == .crop ? .close : .left)
                    .style(color: ColorPalette.gray0, size: 20)
                    .padding(10)
                    .frame(width: 40, height: 40)
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)

            Spacer(minLength: 0)

            Button(action: handleDoneButtonTap) {
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
        HStack {
            Spacer()
            HStack(spacing: 90) {
                actionButton(
                    imageAsset: .crop,
                    title: "자르기",
                    action: enterCropMode
                )
                actionButton(
                    imageAsset: .rotate_left,
                    title: "회전",
                    action: rotateLeft
                )
            }
            Spacer()
        }
        .padding(20)
    }

    private var cropBottomBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 16) {
                ForEach(ImageCropMode.allCases, id: \.self) { mode in
                    cropModeButton(mode)
                }
            }
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
            .padding(.vertical, 6)
        }
    }

    private func rotateLeft() {
        withAnimation(.easeInOut(duration: 0.2)) {
            rotationQuarterTurns += 1
        }
        onRotate()
    }

    private func enterCropMode() {
        selectedImageCropMode = .free
        imageEditMode = .crop
        onCrop()
    }

    private func handleBackButtonTap() {
        if imageEditMode == .crop {
            selectedImageCropMode = .free
            imageEditMode = .edit
            return
        }
        onBack()
    }

    private func handleDoneButtonTap() {
        if imageEditMode == .crop {
            imageEditMode = .edit
            return
        }
        onDone(rotationQuarterTurns)
    }

    @ViewBuilder
    private func cropModeButton(_ mode: ImageCropMode) -> some View {
        let isSelected = selectedImageCropMode == mode
        let foregroundColor = isSelected ? ColorPalette.gray0 : ColorPalette.gray700

        Button {
            selectedImageCropMode = mode
        } label: {
            VStack(spacing: 5) {
                BNImage(mode.imageAsset)
                    .style(
                        color: foregroundColor,
                        size: 22
                    )
                BNText(mode.title)
                    .style(style: .s5sb, color: foregroundColor)
            }
            .frame(minWidth: 37)
            .padding(.vertical, 5.5)
        }
    }
}
