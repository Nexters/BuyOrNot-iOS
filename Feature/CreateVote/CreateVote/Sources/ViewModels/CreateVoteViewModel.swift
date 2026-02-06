//
//  CreateVoteViewModel.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI
import Photos
import PhotosUI
import DesignSystem
import Core

final class CreateVoteViewModel: ObservableObject {
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
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: Image?
    @Published var showPhotoPicker = false
    @Published var showCustomAlert = false
    @Published var showCategoryBottomSheet = false
    
    var contentsLimitCount: Int {
        _contentsLimitCount
    }
    
    private let _accessLevel: PHAccessLevel = .readWrite
    private let _contentsLimitCount = 100
    private let _maxPrice = 100_000_000
    
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

    func didPickedImage(_ image: Image) {
        defer {
            validatePost()
        }
        selectedImage = image
    }

    func didTapDeleteImage() {
        defer {
            validatePost()
        }
        selectedItem = nil
        selectedImage = nil
    }
    
    private func validatePost() {
        let isValidCategory = category != nil
        let isValidImage = selectedItem != nil && selectedImage != nil
        let isValid = isValidImage && isValidCategory
        createButtonState = isValid ? .enabled : .disabled
    }
}
