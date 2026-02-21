//
//  CreateVoteViewModel.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import Foundation
import SwiftUI
import UIKit
import Photos
import PhotosUI
import DesignSystem
import Core
import Domain

public final class CreateVoteViewModel: ObservableObject {
    // TODO: - 26.02.06. 더미 데이터 사용 중 Model 정의 필요
    // ================================
    @Published var contents: String = ""
    @Published var price: String = ""
    @Published var category: String? = nil
    @Published var categories: [String] = [
        "명품∙프리미엄",
        "패션 ∙ 잡화",
        "화장품∙뷰티",
        "트렌드∙가성비템",
        "음식",
        "전자기기",
        "여행 쇼핑템",
        "헬스∙운동용품",
        "도서",
        "기타",
    ]
    // ================================
    
    
    @Published var createButtonState: BNButtonState = .disabled
    @Published var selectedImageData: Data?
    @Published var selectedImage: Image?
    @Published var showPhotoPicker = false
    @Published var showCustomAlert = false
    @Published var showCategoryBottomSheet = false
    
    private let uploadsRepository: UploadsRepository
    private let feedRepository: FeedRepository
    
    var contentsLimitCount: Int {
        _contentsLimitCount
    }
    
    private let _accessLevel: PHAccessLevel = .readWrite
    private let _contentsLimitCount = 100
    private let _maxPrice = 100_000_000

    public init(
        uploadsRepository: UploadsRepository,
        feedRepository: FeedRepository
    ) {
        self.uploadsRepository = uploadsRepository
        self.feedRepository = feedRepository
    }
    
    func didChangeCategory(_ category: String) {
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
    
    @MainActor
    func checkPhotoPermission() async {
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
    
    func didSelectedImage(_ image: Image, _ data: Data) {
        defer {
            validatePost()
        }
        selectedImageData = data
        selectedImage = image
    }
    
    func didTapDeleteImage() {
        defer {
            validatePost()
        }
        selectedImageData = nil
        selectedImage = nil
    }
    
    private func validatePost() {
        let isValidPrice = price.isEmpty == false
        let isValidCategory = category != nil
        let isValidImage = selectedImageData != nil && selectedImage != nil
        let isValid = isValidImage && isValidCategory && isValidPrice
        createButtonState = isValid ? .enabled : .disabled
    }
    
    @MainActor
    func postVote() async -> Bool {
        guard
            let data = selectedImageData,
            let categoryText = category,
            let feedCategory = mapCategory(categoryText),
            let priceValue = price.toInt
        else {
            return false
        }

        let contentType = detectContentType(data) ?? "image/jpeg"
        let fileExtension = contentType == "image/png" ? "png" : "jpg"
        let fileName = "feed_\(UUID().uuidString).\(fileExtension)"
        let imageSize = extractImageSize(data)

        do {
            let imageInfo = try await uploadsRepository.postUploadImage(
                data: data,
                fileName: fileName,
                contentType: contentType
            )

            let info = VoteCreateInfo(
                category: feedCategory,
                price: priceValue,
                content: contents,
                s3ObjectKey: imageInfo.s3ObjectKey,
                imageWidth: imageSize.width,
                imageHeight: imageSize.height
            )
            _ = try await feedRepository.postVoteFeed(info: info)
            NotificationCenter.default.post(name: .voteFeedDidCreate, object: nil)
            return true
        } catch {
            print("[CreateVoteViewModel] postVote error: \(error)")
            return false
        }
    }

    private func mapCategory(_ text: String) -> FeedCategory? {
        if text.contains("명품") { return .luxury }
        if text.contains("패션") { return .fashion }
        if text.contains("화장품") || text.contains("뷰티") { return .beauty }
        if text.contains("음식") { return .food }
        if text.contains("전자기기") { return .electronics }
        if text.contains("여행") { return .travel }
        if text.contains("헬스") || text.contains("운동") { return .health }
        if text.contains("도서") { return .book }
        if text.contains("기타") { return .etc }
        if text.contains("트렌드") || text.contains("가성비") { return .etc }
        return nil
    }

    private func detectContentType(_ data: Data) -> String? {
        let bytes = [UInt8](data.prefix(4))
        if bytes.count >= 2, bytes[0] == 0xFF, bytes[1] == 0xD8 {
            return "image/jpeg"
        }
        if bytes.count >= 4, bytes[0] == 0x89, bytes[1] == 0x50, bytes[2] == 0x4E, bytes[3] == 0x47 {
            return "image/png"
        }
        return nil
    }

    private func extractImageSize(_ data: Data) -> (width: Int, height: Int) {
        guard let image = UIImage(data: data) else {
            return (0, 0)
        }
        if let cgImage = image.cgImage {
            return (cgImage.width, cgImage.height)
        }
        return (Int(image.size.width), Int(image.size.height))
    }
}
