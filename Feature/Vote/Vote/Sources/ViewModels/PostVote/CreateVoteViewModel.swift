//
//  CreateVoteViewModel.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import Foundation
import Combine
import SwiftUI
import UIKit
import Photos
import PhotosUI
import DesignSystem
import Core
import Domain

public final class CreateVoteViewModel: ObservableObject {
    private struct UploadedImage {
        let index: Int
        let imageInfo: ImageInfo
        let imageWidth: Int
        let imageHeight: Int
    }

    struct SelectedPhoto {
        let image: Image
        let data: Data
    }

    @Published var title: String = ""
    @Published var contents: String = ""
    @Published var linkURL: String = ""
    @Published var price: String = ""
    @Published var category: FeedCategory? = nil
    @Published var categories: [FeedCategory] = FeedCategory.allCases
    
    @Published var createButtonState: BNButtonState = .disabled
    @Published var selectedPhotos: [SelectedPhoto] = []
    @Published var showPhotoPicker = false
    @Published var showPhotoSourceBottomSheet = false
    @Published var showCustomAlert = false
    @Published var showCategoryBottomSheet = false
    @Published var showCancelAlert = false
    @Published var showRestorePendingAlert = false
    @Published var snackBar = BNSnackBarManager()
    @Published var isKeyboardVisible = false
    
    private let uploadsRepository: UploadsRepository
    private let feedRepository: FeedRepository
    private let pendingVoteCreateInfoRepository: PendingVoteCreateInfoRepository
    private var anyCancellable = Set<AnyCancellable>()
    private var isPendingAutoSaveEnabled = true
    private var pendingVoteCreateInfoToRestore: PendingVoteCreateInfo?
    
    var contentsLimitCount: Int {
        _contentsLimitCount
    }

    var selectedPhotoCount: Int {
        selectedPhotos.count
    }

    var remainingSelectablePhotoCount: Int {
        max(0, _maxPhotoCount - selectedPhotos.count)
    }

    var isPhotoPickerEnabled: Bool {
        selectedPhotos.count < _maxPhotoCount
    }

    var isWritingInProgress: Bool {
        category != nil || linkURL.isEmpty == false || price.isEmpty == false || title.isEmpty == false || contents.isEmpty == false
    }
    
    private let _accessLevel: PHAccessLevel = .readWrite
    private let _maxPhotoCount = 3
    private let _titleLimitCount = 40
    private let _contentsLimitCount = 100
    private let _maxPrice = 100_000_000

    public init(
        uploadsRepository: UploadsRepository,
        feedRepository: FeedRepository,
        pendingVoteCreateInfoRepository: PendingVoteCreateInfoRepository
    ) {
        self.uploadsRepository = uploadsRepository
        self.feedRepository = feedRepository
        self.pendingVoteCreateInfoRepository = pendingVoteCreateInfoRepository
        bindPendingVoteCreateInfoAutoSave()
    }
    
    func didChangeCategory(_ category: FeedCategory) {
        defer {
            validatePost()
        }
        self.category = category
    }
    
    func didChangePrice(previous: String, text: String) {
        defer {
            validatePost()
        }
        if (!text.isInt) {
            self.price = ""
            return
        }
        guard let price = text.toInt else {
            self.price = ""
            return
        }
        if price > _maxPrice {
            self.price = previous
            return
        }
        self.price = price.toCurrency
    }
    
    func didChangeContents(text: String) {
        if text.count > _contentsLimitCount {
            self.contents = String(text.prefix(_contentsLimitCount))
        }
    }

    func didChangeTitle(text: String) {
        defer {
            validatePost()
        }
        if text.count > _titleLimitCount {
            self.title = String(text.prefix(_titleLimitCount))
        }
    }

    func didChangeLinkURL() {
        validatePost()
    }

    func didTapAddPhotoButton() {
        guard isPhotoPickerEnabled else {
            return
        }
        showPhotoSourceBottomSheet = true
    }

    @MainActor
    func checkPhotoPermission() async {
        guard isPhotoPickerEnabled else {
            return
        }
        let status = PHPhotoLibrary.authorizationStatus(for: _accessLevel)
        switch status {
        case .authorized, .limited:
            showPhotoPicker = true
        case .denied, .restricted:
            showCustomAlert = true
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: _accessLevel)
            if newStatus == .authorized || newStatus == .limited {
                showPhotoPicker = true
            } else {
                showCustomAlert = true
            }
        @unknown default:
            showCustomAlert = true
        }
    }
    
    @MainActor
    func openPhotoAuthorizationSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
        UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func didSelectPhotos(_ photos: [SinglePhotoPicker.PickedPhoto]) {
        defer {
            validatePost()
        }
        guard photos.isEmpty == false else {
            return
        }
        let remaining = remainingSelectablePhotoCount
        guard remaining > 0 else {
            return
        }
        let newPhotos = photos
            .prefix(remaining)
            .map { SelectedPhoto(image: $0.image, data: $0.data) }
        selectedPhotos.append(contentsOf: newPhotos)
    }
    
    func didTapDeleteImage(at index: Int) {
        defer {
            validatePost()
        }
        guard selectedPhotos.indices.contains(index) else {
            return
        }
        selectedPhotos.remove(at: index)
    }

    func didTapCancel() {
        if isWritingInProgress {
            showCancelAlert = true
        }
    }

    func keyboardWillShow() {
        isKeyboardVisible = true
    }

    func keyboardWillHide() {
        isKeyboardVisible = false
    }

    @discardableResult
    func checkPendingVoteCreateInfoOnAppear() -> Bool {
        guard pendingVoteCreateInfoToRestore == nil else {
            return false
        }
        guard let info = pendingVoteCreateInfoRepository.getPendingVoteCreateInfo() else {
            return false
        }
        guard info.category != nil || info.linkURL.isEmpty == false || info.price.isEmpty == false || info.title.isEmpty == false || info.content.isEmpty == false else {
            return false
        }
        pendingVoteCreateInfoToRestore = info
        showRestorePendingAlert = true
        return true
    }

    func restorePendingVoteCreateInfo() {
        guard let info = pendingVoteCreateInfoToRestore else {
            return
        }
        category = info.category
        linkURL = info.linkURL
        price = info.price
        title = info.title
        contents = info.content
        validatePost()
        showRestorePendingAlert = false
    }

    func removePendingVoteCreateInfo() {
        isPendingAutoSaveEnabled = false
        anyCancellable.removeAll()
        pendingVoteCreateInfoRepository.removePendingVoteCreateInfo()
    }

    @MainActor
    func validateLinkURLBeforePost() -> Bool {
        guard LinkValidator.isValid(linkURL) else {
            snackBar.addItem(
                BNSnackBarItem(
                    text: "링크 주소를 다시 확인해 주세요."
                )
            )
            createButtonState = .disabled
            return false
        }
        validatePost()
        return true
    }
    
    private func validatePost() {
        let isValidPrice = price.isEmpty == false
        let isValidCategory = category != nil
        let isValidImage = selectedPhotos.isEmpty == false
        let isValidTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        let isValid = isValidImage && isValidCategory && isValidPrice && isValidTitle
        createButtonState = isValid ? .enabled : .disabled
    }

    private func bindPendingVoteCreateInfoAutoSave() {
        Publishers.CombineLatest(
            Publishers.CombineLatest4($category, $linkURL, $price, $title),
            $contents
        )
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] values, contents in
                guard let self, self.isPendingAutoSaveEnabled else {
                    return
                }
                let (category, linkURL, price, title) = values
                let info = PendingVoteCreateInfo(
                    category: category,
                    linkURL: linkURL,
                    title: title,
                    price: price,
                    content: contents
                )
                self.pendingVoteCreateInfoRepository.savePendingVoteCreateInfo(info)
            }
            .store(in: &anyCancellable)
    }

    @MainActor
    func postVote() async -> Bool {
        guard
            selectedPhotos.isEmpty == false,
            let selectedCategory = category,
            let priceValue = price.toInt
        else {
            return false
        }

        do {
            let photoDatas = selectedPhotos.map(\.data)
            let imageUploads = try await withThrowingTaskGroup(
                of: UploadedImage.self
            ) { group in
                for (index, data) in photoDatas.enumerated() {
                    group.addTask { [uploadsRepository] in
                        let contentType = Self.detectContentType(data) ?? "image/jpeg"
                        let fileExtension = contentType == "image/png" ? "png" : "jpg"
                        let fileName = "feed_\(UUID().uuidString).\(fileExtension)"
                        let imageSize = Self.extractImageSize(data)
                        let imageInfo = try await uploadsRepository.postUploadImage(
                            data: data,
                            fileName: fileName,
                            contentType: contentType
                        )
                        return UploadedImage(
                            index: index,
                            imageInfo: imageInfo,
                            imageWidth: imageSize.width,
                            imageHeight: imageSize.height
                        )
                    }
                }

                var uploads: [UploadedImage] = []
                for try await value in group {
                    uploads.append(value)
                }
                return uploads.sorted { $0.index < $1.index }
            }

            let info = VoteCreateInfo(
                category: selectedCategory,
                price: priceValue,
                link: linkURL,
                title: title,
                content: contents,
                images: imageUploads.map { upload in
                    VoteCreateInfo.Image(
                        s3ObjectKey: upload.imageInfo.s3ObjectKey,
                        imageWidth: upload.imageWidth,
                        imageHeight: upload.imageHeight
                    )
                }
            )
            _ = try await feedRepository.postVoteFeed(info: info)
            NotificationCenter.default.post(name: .voteFeedDidCreate, object: nil)
            return true
        } catch {
            print("[CreateVoteViewModel] postVote error: \(error)")
            return false
        }
    }

    private static func detectContentType(_ data: Data) -> String? {
        let bytes = [UInt8](data.prefix(4))
        if bytes.count >= 2, bytes[0] == 0xFF, bytes[1] == 0xD8 {
            return "image/jpeg"
        }
        if bytes.count >= 4, bytes[0] == 0x89, bytes[1] == 0x50, bytes[2] == 0x4E, bytes[3] == 0x47 {
            return "image/png"
        }
        return nil
    }

    private static func extractImageSize(_ data: Data) -> (width: Int, height: Int) {
        guard let image = UIImage(data: data) else {
            return (0, 0)
        }
        if let cgImage = image.cgImage {
            return (cgImage.width, cgImage.height)
        }
        return (Int(image.size.width), Int(image.size.height))
    }
}
