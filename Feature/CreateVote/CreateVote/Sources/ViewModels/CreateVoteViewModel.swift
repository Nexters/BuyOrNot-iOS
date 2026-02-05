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

@Observable
final class CreateVoteViewModel: ObservableObject {
    // MARK: - Model 정의 필요
    var contents: String = ""
    var price: String = ""
    var category: String? = String(repeating: "b", count: 10)
    var categories: [String] = "abcdefghijklmnop".map { c in
        String(repeating: c, count: 10)
    }
    
    var createButtonState: BNButtonState = .disabled
    
    var focusField: FocusedTextField? = .price
    
    var selectedItem: PhotosPickerItem?
    var selectedImage: Image?
    var showPhotoPicker = false
    var showCustomAlert = false
    var showCategoryBottomSheet = false
    
    var contentsLimitCount: Int {
        _contentsLimitCount
    }
    
    private let _accessLevel: PHAccessLevel = .readWrite
    private let _contentsLimitCount = 100
    private let _maxPrice = 100_000_000
    
    func didChangePrice(previous: String, text: String) {
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
    
    func didTapContentsTextField() {
        focusField = .contents
    }
    
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
    
    func loadImage() async {
        guard let item = selectedItem else { return }
        do {
            if let image = try await item.loadTransferable(type: Image.self) {
                selectedImage = image
            }
        } catch {
            print("\(error)")
        }
    }
}
