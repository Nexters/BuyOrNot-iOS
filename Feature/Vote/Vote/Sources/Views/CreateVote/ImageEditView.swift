//
//  ImageEditView.swift
//  Vote
//
//  Created by 문종식 on 5/27/26.
//

import SwiftUI
import UIKit
import DesignSystem

private enum ImageDataFormat {
    case jpeg
    case png
}

private enum CropAnchorHandle: CaseIterable {
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
}

struct ImageEditView: View {
    private let cropAnchorSize: CGFloat = 22
    private let cropHorizontalPaddingFromScreen: CGFloat = 20
    private let minimumCropPixelLength: CGFloat = 1

    private let onBack: () -> Void
    private let onDone: (ImageEditResult) -> Void
    private let onCrop: () -> Void
    private let onRotate: () -> Void
    private let sourceFormat: ImageDataFormat

    @State private var imageEditMode: ImageEditMode = .edit
    @State private var selectedImageCropMode: ImageCropMode = .free
    @State private var committedCropAnchors: ImageCropAnchors?
    @State private var editingCropAnchors: ImageCropAnchors = .full

    @State private var sourceImage: UIImage
    @State private var workingImage: UIImage

    @State private var appliedRotationQuarterTurns: Int
    @State private var previewRotationQuarterTurns: Int = 0
    @State private var isRotationAnimating: Bool = false

    @State private var draggingAnchorStart: ImageCropAnchors?
    @State private var movingCropStart: ImageCropAnchors?

    init(
        sourceData: Data,
        initialEditState: ImageEditState = .identity,
        onBack: @escaping () -> Void = {},
        onDone: @escaping (ImageEditResult) -> Void = { _ in },
        onCrop: @escaping () -> Void = {},
        onRotate: @escaping () -> Void = {}
    ) {
        let normalizedEditState = ImageEditState(
            rotationQuarterTurns: initialEditState.rotationQuarterTurns,
            cropAnchors: initialEditState.cropAnchors
        )
        let initialUIImage = Self.makeInitialImage(from: sourceData)
        let initialSourceImage = Self.rotateLeft(
            initialUIImage,
            quarterTurns: normalizedEditState.rotationQuarterTurns
        )
        let initialWorkingImage = Self.makeWorkingImage(
            from: initialSourceImage,
            anchors: normalizedEditState.cropAnchors,
            minimumCropPixelLength: 1
        )
        _committedCropAnchors = State(initialValue: normalizedEditState.cropAnchors)
        _editingCropAnchors = State(initialValue: normalizedEditState.cropAnchors ?? .full)
        _sourceImage = State(initialValue: initialSourceImage)
        _workingImage = State(initialValue: initialWorkingImage)
        _appliedRotationQuarterTurns = State(initialValue: normalizedEditState.rotationQuarterTurns)
        sourceFormat = Self.detectImageDataFormat(sourceData)
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
                    .padding(.top, imageEditMode == .crop ? 12 + cropAnchorSize/2 : 0)
                    .padding(.bottom, imageEditMode == .crop ? cropAnchorSize/2 : 0)
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
                BNImage(.close)
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
            if imageEditMode == .crop {
                let imageRect = displayedImageRect(
                    in: size,
                    horizontalInset: cropImageHorizontalInset,
                    imageSize: normalizedSize(of: sourceImage)
                )
                let cropPathPoints = editingCropAnchors.projectedPoints(in: imageRect)

                ZStack {
                    Image(uiImage: sourceImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageRect.width, height: imageRect.height)
                        .position(x: imageRect.midX, y: imageRect.midY)

                    cropOutsideOverlay(
                        imageRect: imageRect,
                        cropPoints: cropPathPoints
                    )
                    cropMoveHitArea(
                        imageRect: imageRect,
                        cropPoints: cropPathPoints
                    )
                    cropLine(pathPoints: cropPathPoints)
                    cropAnchors(
                        pathPoints: cropPathPoints,
                        imageRect: imageRect
                    )
                }
                .frame(width: size.width, height: size.height)
            } else {
                Image(uiImage: workingImage)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: isPreviewRightAngleRotation ? size.height : size.width,
                        height: isPreviewRightAngleRotation ? size.width : size.height
                    )
                    .rotationEffect(.degrees(Double(previewRotationQuarterTurns * -90)))
                    .frame(width: size.width, height: size.height)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var isPreviewRightAngleRotation: Bool {
        previewRotationQuarterTurns % 2 != 0
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
        guard isRotationAnimating == false else { return }

        let rotatedSource = Self.rotateLeft90(sourceImage)
        let rotatedCommittedAnchors = committedCropAnchors.map(rotateAnchorsLeft90)
        let rotatedWorking = makeWorkingImage(
            from: rotatedSource,
            anchors: rotatedCommittedAnchors
        )

        isRotationAnimating = true
        withAnimation(.easeInOut(duration: 0.2)) {
            previewRotationQuarterTurns = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sourceImage = rotatedSource
            committedCropAnchors = rotatedCommittedAnchors
            workingImage = rotatedWorking
            appliedRotationQuarterTurns = ImageEditState.normalize(appliedRotationQuarterTurns + 1)
            withAnimation(.none) {
                previewRotationQuarterTurns = 0
            }
            isRotationAnimating = false
            onRotate()
        }
    }

    private func enterCropMode() {
        selectedImageCropMode = .free
        editingCropAnchors = committedCropAnchors ?? .full
        imageEditMode = .crop
        onCrop()
    }

    private func handleBackButtonTap() {
        if imageEditMode == .crop {
            selectedImageCropMode = .free
            editingCropAnchors = committedCropAnchors ?? .full
            imageEditMode = .edit
            draggingAnchorStart = nil
            movingCropStart = nil
            return
        }
        onBack()
    }

    private func handleDoneButtonTap() {
        if imageEditMode == .crop {
            let committed = editingCropAnchors
            committedCropAnchors = committed == .full ? nil : committed
            workingImage = makeWorkingImage(
                from: sourceImage,
                anchors: committedCropAnchors
            )
            selectedImageCropMode = .free
            draggingAnchorStart = nil
            movingCropStart = nil
            imageEditMode = .edit
            return
        }

        guard let outputData = encodedData(from: workingImage, format: sourceFormat) else {
            return
        }
        onDone(
            ImageEditResult(
                image: Image(uiImage: workingImage),
                data: outputData,
                state: ImageEditState(
                    rotationQuarterTurns: appliedRotationQuarterTurns,
                    cropAnchors: committedCropAnchors
                )
            )
        )
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

        guard mode != .free else { return }
        editingCropAnchors = maximumCenteredAnchors(for: mode)
    }

    private func maximumCenteredAnchors(for mode: ImageCropMode) -> ImageCropAnchors {
        guard let targetAspectRatio = mode.fixedAspectRatio else {
            return editingCropAnchors
        }

        let imageSize = normalizedSize(of: sourceImage)
        guard imageSize.width > 0, imageSize.height > 0 else {
            return .full
        }

        let imageAspectRatio = imageSize.width / imageSize.height
        guard imageAspectRatio > 0 else { return .full }

        let normalizedAspectRatio = targetAspectRatio / imageAspectRatio
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

        return ImageCropAnchors.from(
            minX: originX,
            maxX: originX + cropWidth,
            minY: originY,
            maxY: originY + cropHeight
        )
    }

    private var cropImageHorizontalInset: CGFloat {
        cropHorizontalPaddingFromScreen + cropAnchorSize / 2
    }

    private func displayedImageRect(
        in containerSize: CGSize,
        horizontalInset: CGFloat = 0,
        imageSize: CGSize
    ) -> CGRect {
        let clampedInset = max(horizontalInset, 0)
        let layoutRect = CGRect(
            x: clampedInset,
            y: 0,
            width: max(containerSize.width - (clampedInset * 2), 1),
            height: max(containerSize.height, 1)
        )

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
    private func cropMoveHitArea(
        imageRect: CGRect,
        cropPoints: [CGPoint]
    ) -> some View {
        Path { path in
            guard cropPoints.count == 4 else { return }
            path.move(to: cropPoints[0])
            for point in cropPoints.dropFirst() {
                path.addLine(to: point)
            }
            path.closeSubpath()
        }
        .fill(Color.white.opacity(0.001))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    moveCrop(by: value.translation, in: imageRect)
                }
                .onEnded { _ in
                    movingCropStart = nil
                }
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
    private func cropAnchors(
        pathPoints: [CGPoint],
        imageRect: CGRect
    ) -> some View {
        ForEach(Array(CropAnchorHandle.allCases.enumerated()), id: \.offset) { index, handle in
            if pathPoints.indices.contains(index) {
                Circle()
                    .fill(ColorPalette.gray0)
                    .frame(width: cropAnchorSize, height: cropAnchorSize)
                    .position(pathPoints[index])
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                dragAnchor(
                                    handle,
                                    by: value.translation,
                                    in: imageRect
                                )
                            }
                            .onEnded { _ in
                                draggingAnchorStart = nil
                            }
                    )
            }
        }
    }

    private func dragAnchor(
        _ handle: CropAnchorHandle,
        by translation: CGSize,
        in imageRect: CGRect
    ) {
        guard imageRect.width > 0, imageRect.height > 0 else { return }

        if draggingAnchorStart == nil {
            draggingAnchorStart = editingCropAnchors
        }
        guard let start = draggingAnchorStart else { return }

        let delta = CGPoint(
            x: translation.width / imageRect.width,
            y: translation.height / imageRect.height
        )

        if let fixedRatio = selectedImageCropMode.fixedAspectRatio {
            editingCropAnchors = dragAnchorWithFixedRatio(
                handle,
                from: start,
                delta: delta,
                fixedAspectRatio: fixedRatio
            )
        } else {
            editingCropAnchors = dragAnchorFreely(
                handle,
                from: start,
                delta: delta
            )
        }
    }

    private func moveCrop(by translation: CGSize, in imageRect: CGRect) {
        guard imageRect.width > 0, imageRect.height > 0 else { return }

        if movingCropStart == nil {
            movingCropStart = editingCropAnchors
        }
        guard let start = movingCropStart else { return }

        let deltaX = translation.width / imageRect.width
        let deltaY = translation.height / imageRect.height

        let width = start.width
        let height = start.height

        let newMinX = clamp(start.minX + deltaX, min: 0, max: 1 - width)
        let newMinY = clamp(start.minY + deltaY, min: 0, max: 1 - height)

        editingCropAnchors = ImageCropAnchors.from(
            minX: newMinX,
            maxX: newMinX + width,
            minY: newMinY,
            maxY: newMinY + height
        )
    }

    private func dragAnchorFreely(
        _ handle: CropAnchorHandle,
        from start: ImageCropAnchors,
        delta: CGPoint
    ) -> ImageCropAnchors {
        let minWidth = minimumNormalizedWidth
        let minHeight = minimumNormalizedHeight

        switch handle {
        case .topLeft:
            let minX = clamp(start.minX + delta.x, min: 0, max: start.maxX - minWidth)
            let minY = clamp(start.minY + delta.y, min: 0, max: start.maxY - minHeight)
            return .from(minX: minX, maxX: start.maxX, minY: minY, maxY: start.maxY)

        case .topRight:
            let maxX = clamp(start.maxX + delta.x, min: start.minX + minWidth, max: 1)
            let minY = clamp(start.minY + delta.y, min: 0, max: start.maxY - minHeight)
            return .from(minX: start.minX, maxX: maxX, minY: minY, maxY: start.maxY)

        case .bottomRight:
            let maxX = clamp(start.maxX + delta.x, min: start.minX + minWidth, max: 1)
            let maxY = clamp(start.maxY + delta.y, min: start.minY + minHeight, max: 1)
            return .from(minX: start.minX, maxX: maxX, minY: start.minY, maxY: maxY)

        case .bottomLeft:
            let minX = clamp(start.minX + delta.x, min: 0, max: start.maxX - minWidth)
            let maxY = clamp(start.maxY + delta.y, min: start.minY + minHeight, max: 1)
            return .from(minX: minX, maxX: start.maxX, minY: start.minY, maxY: maxY)
        }
    }

    private func dragAnchorWithFixedRatio(
        _ handle: CropAnchorHandle,
        from start: ImageCropAnchors,
        delta: CGPoint,
        fixedAspectRatio: CGFloat
    ) -> ImageCropAnchors {
        let cropBaseSize = normalizedSize(of: sourceImage)
        let imageAspectRatio = max(cropBaseSize.width / cropBaseSize.height, 0.0001)
        let normalizedAspectRatio = fixedAspectRatio / imageAspectRatio

        let opposite = oppositePoint(for: handle, in: start)
        let startHandle = anchorPoint(for: handle, in: start)

        let draggedHandle = CGPoint(
            x: startHandle.x + delta.x,
            y: startHandle.y + delta.y
        )

        let widthFromX = abs(draggedHandle.x - opposite.x)
        let widthFromY = abs(draggedHandle.y - opposite.y) * normalizedAspectRatio
        let candidateWidth = abs(delta.x) >= abs(delta.y) ? widthFromX : widthFromY

        let widthBounds = widthBounds(for: handle, opposite: opposite)
        let minWidth = max(
            minimumNormalizedWidth,
            minimumNormalizedHeight * normalizedAspectRatio
        )
        let maxWidth = max(
            min(widthBounds.maxByX, widthBounds.maxByY * normalizedAspectRatio),
            minWidth
        )

        let width = clamp(candidateWidth, min: minWidth, max: maxWidth)
        let height = width / normalizedAspectRatio

        return anchors(
            for: handle,
            opposite: opposite,
            width: width,
            height: height
        )
    }

    private func widthBounds(
        for handle: CropAnchorHandle,
        opposite: CGPoint
    ) -> (maxByX: CGFloat, maxByY: CGFloat) {
        switch handle {
        case .topLeft:
            return (maxByX: opposite.x, maxByY: opposite.y)
        case .topRight:
            return (maxByX: 1 - opposite.x, maxByY: opposite.y)
        case .bottomRight:
            return (maxByX: 1 - opposite.x, maxByY: 1 - opposite.y)
        case .bottomLeft:
            return (maxByX: opposite.x, maxByY: 1 - opposite.y)
        }
    }

    private func anchors(
        for handle: CropAnchorHandle,
        opposite: CGPoint,
        width: CGFloat,
        height: CGFloat
    ) -> ImageCropAnchors {
        switch handle {
        case .topLeft:
            return .from(
                minX: opposite.x - width,
                maxX: opposite.x,
                minY: opposite.y - height,
                maxY: opposite.y
            )
        case .topRight:
            return .from(
                minX: opposite.x,
                maxX: opposite.x + width,
                minY: opposite.y - height,
                maxY: opposite.y
            )
        case .bottomRight:
            return .from(
                minX: opposite.x,
                maxX: opposite.x + width,
                minY: opposite.y,
                maxY: opposite.y + height
            )
        case .bottomLeft:
            return .from(
                minX: opposite.x - width,
                maxX: opposite.x,
                minY: opposite.y,
                maxY: opposite.y + height
            )
        }
    }

    private func oppositePoint(for handle: CropAnchorHandle, in anchors: ImageCropAnchors) -> CGPoint {
        switch handle {
        case .topLeft:
            return anchors.bottomRight
        case .topRight:
            return anchors.bottomLeft
        case .bottomRight:
            return anchors.topLeft
        case .bottomLeft:
            return anchors.topRight
        }
    }

    private func anchorPoint(for handle: CropAnchorHandle, in anchors: ImageCropAnchors) -> CGPoint {
        switch handle {
        case .topLeft:
            return anchors.topLeft
        case .topRight:
            return anchors.topRight
        case .bottomRight:
            return anchors.bottomRight
        case .bottomLeft:
            return anchors.bottomLeft
        }
    }

    private var minimumNormalizedWidth: CGFloat {
        let pixelWidth = max(pixelSize(of: sourceImage).width, 1)
        return min(1, minimumCropPixelLength / pixelWidth)
    }

    private var minimumNormalizedHeight: CGFloat {
        let pixelHeight = max(pixelSize(of: sourceImage).height, 1)
        return min(1, minimumCropPixelLength / pixelHeight)
    }

    private func makeWorkingImage(
        from image: UIImage,
        anchors: ImageCropAnchors?
    ) -> UIImage {
        Self.makeWorkingImage(
            from: image,
            anchors: anchors,
            minimumCropPixelLength: minimumCropPixelLength
        )
    }

    private func rotateAnchorsLeft90(_ anchors: ImageCropAnchors) -> ImageCropAnchors {
        ImageCropAnchors.from(
            minX: anchors.minY,
            maxX: anchors.maxY,
            minY: 1 - anchors.maxX,
            maxY: 1 - anchors.minX
        )
    }

    private func cropImage(_ image: UIImage, with anchors: ImageCropAnchors) -> UIImage? {
        Self.cropImage(
            image,
            with: anchors,
            minimumCropPixelLength: minimumCropPixelLength
        )
    }

    private func encodedData(from image: UIImage, format: ImageDataFormat) -> Data? {
        let normalized = Self.normalizeOrientation(image)
        switch format {
        case .png:
            return normalized.pngData()
        case .jpeg:
            return normalized.jpegData(compressionQuality: 0.9)
        }
    }

    private func normalizedSize(of image: UIImage) -> CGSize {
        let normalized = Self.normalizeOrientation(image)
        guard normalized.size.width > 0, normalized.size.height > 0 else {
            return CGSize(width: 1, height: 1)
        }
        return normalized.size
    }

    private func pixelSize(of image: UIImage) -> CGSize {
        let normalized = Self.normalizeOrientation(image)
        if let cgImage = normalized.cgImage {
            return CGSize(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
        }
        return CGSize(
            width: max(normalized.size.width * normalized.scale, 1),
            height: max(normalized.size.height * normalized.scale, 1)
        )
    }

    private func clamp(_ value: CGFloat, min lower: CGFloat, max upper: CGFloat) -> CGFloat {
        Swift.max(lower, Swift.min(upper, value))
    }

    private static func makeInitialImage(from data: Data) -> UIImage {
        if let decoded = UIImage(data: data) {
            return normalizeOrientation(decoded)
        }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { context in
            UIColor.black.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

    private static func normalizeOrientation(_ image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else {
            return image
        }
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = image.scale
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }

    private static func rotateLeft90(_ image: UIImage) -> UIImage {
        let normalized = normalizeOrientation(image)
        guard let cgImage = normalized.cgImage else { return normalized }
        let oriented = UIImage(
            cgImage: cgImage,
            scale: normalized.scale,
            orientation: .left
        )
        return normalizeOrientation(oriented)
    }

    private static func rotateLeft(_ image: UIImage, quarterTurns: Int) -> UIImage {
        let normalizedQuarterTurns = ImageEditState.normalize(quarterTurns)
        guard normalizedQuarterTurns > 0 else {
            return image
        }

        var rotatedImage = image
        for _ in 0..<normalizedQuarterTurns {
            rotatedImage = rotateLeft90(rotatedImage)
        }
        return rotatedImage
    }

    private static func makeWorkingImage(
        from image: UIImage,
        anchors: ImageCropAnchors?,
        minimumCropPixelLength: CGFloat
    ) -> UIImage {
        guard let anchors else {
            return image
        }
        return cropImage(
            image,
            with: anchors,
            minimumCropPixelLength: minimumCropPixelLength
        ) ?? image
    }

    private static func cropImage(
        _ image: UIImage,
        with anchors: ImageCropAnchors,
        minimumCropPixelLength: CGFloat
    ) -> UIImage? {
        let normalized = normalizeOrientation(image)
        guard let cgImage = normalized.cgImage else { return nil }

        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)

        let minimumWidth = min(1, minimumCropPixelLength / max(imageWidth, 1))
        let minimumHeight = min(1, minimumCropPixelLength / max(imageHeight, 1))

        let minX = clamp(anchors.minX, min: 0, max: 1)
        let minY = clamp(anchors.minY, min: 0, max: 1)
        let width = clamp(anchors.width, min: minimumWidth, max: 1)
        let height = clamp(anchors.height, min: minimumHeight, max: 1)

        var cropRect = CGRect(
            x: minX * imageWidth,
            y: minY * imageHeight,
            width: width * imageWidth,
            height: height * imageHeight
        ).integral

        cropRect.origin.x = clamp(cropRect.origin.x, min: 0, max: imageWidth - 1)
        cropRect.origin.y = clamp(cropRect.origin.y, min: 0, max: imageHeight - 1)
        cropRect.size.width = clamp(cropRect.size.width, min: 1, max: imageWidth - cropRect.origin.x)
        cropRect.size.height = clamp(cropRect.size.height, min: 1, max: imageHeight - cropRect.origin.y)

        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: croppedCGImage, scale: normalized.scale, orientation: .up)
    }

    private static func detectImageDataFormat(_ data: Data) -> ImageDataFormat {
        let bytes = [UInt8](data.prefix(8))
        let isPNG = bytes.count >= 4
            && bytes[0] == 0x89
            && bytes[1] == 0x50
            && bytes[2] == 0x4E
            && bytes[3] == 0x47
        return isPNG ? .png : .jpeg
    }

    private static func clamp(_ value: CGFloat, min lower: CGFloat, max upper: CGFloat) -> CGFloat {
        max(lower, min(upper, value))
    }
}
