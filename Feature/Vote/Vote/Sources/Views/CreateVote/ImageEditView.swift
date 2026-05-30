//
//  ImageEditView.swift
//  Vote
//
//  Created by 문종식 on 5/27/26.
//

import SwiftUI
import DesignSystem

public struct ImageEditView: View {
    private let cropAnchorSize: CGFloat = 22
    private let cropHorizontalPaddingFromScreen: CGFloat = 20
    private let image: Image
    private let sourceImageSize: CGSize
    private let onBack: () -> Void
    private let onDone: (Int) -> Void
    private let onCrop: () -> Void
    private let onRotate: () -> Void
    @State private var imageEditMode: ImageEditMode = .edit
    @State private var rotationQuarterTurns: Int = 0
    @State private var selectedImageCropMode: ImageCropMode = .free
    @State private var cropAnchorHistory: ImageCropAnchors?
    @State private var editingCropAnchors: ImageCropAnchors = .full

    public init(
        image: Image = Image(systemName: "photo"),
        sourceImageSize: CGSize = .zero,
        onBack: @escaping () -> Void = {},
        onDone: @escaping (Int) -> Void = { _ in },
        onCrop: @escaping () -> Void = {},
        onRotate: @escaping () -> Void = {}
    ) {
        self.image = image
        self.sourceImageSize = sourceImageSize
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
            let imageRect = displayedImageRect(
                in: size,
                horizontalInset: imageEditMode == .crop ? cropImageHorizontalInset : 0
            )
            let renderRect = renderedImageRect(beforeRotationFrom: imageRect)
            let cropPathPoints = editingCropAnchors.projectedPoints(in: renderRect)

            ZStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: renderRect.width, height: renderRect.height)
                    .position(x: renderRect.midX, y: renderRect.midY)

                if imageEditMode == .crop {
                    cropOutsideOverlay(
                        imageRect: renderRect,
                        cropPoints: cropPathPoints
                    )
                    cropLine(pathPoints: cropPathPoints)
                    cropAnchors(pathPoints: cropPathPoints)
                }
            }
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
        editingCropAnchors = cropAnchorHistory ?? .full
        imageEditMode = .crop
        onCrop()
    }

    private func handleBackButtonTap() {
        if imageEditMode == .crop {
            selectedImageCropMode = .free
            editingCropAnchors = cropAnchorHistory ?? .full
            imageEditMode = .edit
            return
        }
        onBack()
    }

    private func handleDoneButtonTap() {
        if imageEditMode == .crop {
            cropAnchorHistory = editingCropAnchors
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
            selectCropMode(mode)
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

    private func selectCropMode(_ mode: ImageCropMode) {
        selectedImageCropMode = mode

        // Free mode keeps current anchors as-is.
        guard mode != .free else { return }

        editingCropAnchors = maximumCenteredAnchors(for: mode)
    }

    private func maximumCenteredAnchors(for mode: ImageCropMode) -> ImageCropAnchors {
        guard let targetAspectRatio = mode.fixedAspectRatio else {
            return editingCropAnchors
        }

        let imageSize = baseImageSizeForLayout
        guard imageSize.width > 0, imageSize.height > 0 else {
            return .full
        }

        let adjustedTargetAspectRatio = isRightAngleRotation
            ? (1 / targetAspectRatio)
            : targetAspectRatio
        let imageAspectRatio = imageSize.width / imageSize.height
        guard imageAspectRatio > 0 else { return .full }

        // Convert target aspect ratio to normalized-space aspect.
        let normalizedAspectRatio = adjustedTargetAspectRatio / imageAspectRatio
        let cropWidth: CGFloat
        let cropHeight: CGFloat

        if normalizedAspectRatio >= 1 {
            cropWidth = 1
            cropHeight = max(min(1 / normalizedAspectRatio, 1), 0)
        } else {
            cropWidth = max(min(normalizedAspectRatio, 1), 0)
            cropHeight = 1
        }

        let originX = (1 - cropWidth) / 2
        let originY = (1 - cropHeight) / 2

        return ImageCropAnchors(
            topLeft: CGPoint(x: originX, y: originY),
            topRight: CGPoint(x: originX + cropWidth, y: originY),
            bottomRight: CGPoint(x: originX + cropWidth, y: originY + cropHeight),
            bottomLeft: CGPoint(x: originX, y: originY + cropHeight)
        )
    }

    private var cropImageHorizontalInset: CGFloat {
        cropHorizontalPaddingFromScreen + cropAnchorSize / 2
    }

    private func displayedImageRect(
        in containerSize: CGSize,
        horizontalInset: CGFloat = 0
    ) -> CGRect {
        let clampedInset = max(horizontalInset, 0)
        let layoutRect = CGRect(
            x: clampedInset,
            y: 0,
            width: max(containerSize.width - (clampedInset * 2), 1),
            height: max(containerSize.height, 1)
        )
        let imageSize = effectiveImageSizeForLayout

        guard imageSize.width > 0, imageSize.height > 0 else {
            return layoutRect
        }

        let scale = min(
            layoutRect.width / imageSize.width,
            layoutRect.height / imageSize.height
        )
        let fittedSize = CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )
        return CGRect(
            x: layoutRect.minX + (layoutRect.width - fittedSize.width) / 2,
            y: layoutRect.minY + (layoutRect.height - fittedSize.height) / 2,
            width: fittedSize.width,
            height: fittedSize.height
        )
    }

    private var effectiveImageSizeForLayout: CGSize {
        let base = baseImageSizeForLayout
        guard isRightAngleRotation else { return base }
        return CGSize(width: base.height, height: base.width)
    }

    private var baseImageSizeForLayout: CGSize {
        sourceImageSize.width > 0 && sourceImageSize.height > 0
            ? sourceImageSize
            : CGSize(width: 1, height: 1)
    }

    private func renderedImageRect(beforeRotationFrom displayedRect: CGRect) -> CGRect {
        guard isRightAngleRotation else { return displayedRect }
        return CGRect(
            x: displayedRect.midX - displayedRect.height / 2,
            y: displayedRect.midY - displayedRect.width / 2,
            width: displayedRect.height,
            height: displayedRect.width
        )
    }

    @ViewBuilder
    private func cropOutsideOverlay(
        imageRect: CGRect,
        cropPoints: [CGPoint]
    ) -> some View {
        Path { path in
            path.addRect(imageRect)
            guard cropPoints.count == 4 else { return }
            path.move(to: cropPoints[0])
            for point in cropPoints.dropFirst() {
                path.addLine(to: point)
            }
            path.closeSubpath()
        }
        .fill(
            Color.black.opacity(0.7),
            style: FillStyle(eoFill: true)
        )
    }

    @ViewBuilder
    private func cropLine(pathPoints: [CGPoint]) -> some View {
        Path { path in
            guard pathPoints.count == 4 else { return }
            path.move(to: pathPoints[0])
            for point in pathPoints.dropFirst() {
                path.addLine(to: point)
            }
            path.closeSubpath()
        }
        .stroke(ColorPalette.gray0, lineWidth: 1)
    }

    @ViewBuilder
    private func cropAnchors(pathPoints: [CGPoint]) -> some View {
        ForEach(Array(pathPoints.enumerated()), id: \.offset) { _, point in
            Circle()
                .fill(ColorPalette.gray0)
                .frame(width: cropAnchorSize, height: cropAnchorSize)
                .position(point)
        }
    }
}
