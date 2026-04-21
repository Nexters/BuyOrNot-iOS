//
//  SinglePhotoPicker.swift
//  Core
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

public struct SinglePhotoPicker: UIViewControllerRepresentable {
    public struct PickedPhoto {
        public let image: Image
        public let data: Data

        public init(image: Image, data: Data) {
            self.image = image
            self.data = data
        }
    }

    private let selectionLimit: Int
    private let onPicked: (Image, Data) -> Void
    private let onPickedItems: ([PickedPhoto]) -> Void
    
    public init(onPicked: @escaping (Image) -> Void) {
        self.selectionLimit = 1
        self.onPicked = { image, _ in
            onPicked(image)
        }
        self.onPickedItems = { _ in }
    }
    
    public init(onPicked: @escaping (Image, Data) -> Void) {
        self.selectionLimit = 1
        self.onPicked = onPicked
        self.onPickedItems = { _ in }
    }

    public init(
        selectionLimit: Int,
        onPickedItems: @escaping ([PickedPhoto]) -> Void
    ) {
        self.selectionLimit = max(1, selectionLimit)
        self.onPicked = { _, _ in }
        self.onPickedItems = onPickedItems
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = selectionLimit
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: SinglePhotoPicker
        
        init(_ parent: SinglePhotoPicker) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard results.isEmpty == false else {
                return
            }

            let lock = NSLock()
            let group = DispatchGroup()
            var loadedItems: [(Int, PickedPhoto)] = []

            for (index, result) in results.enumerated() {
                group.enter()
                loadPickedPhoto(from: result.itemProvider) { pickedPhoto in
                    defer { group.leave() }
                    guard let pickedPhoto else { return }
                    lock.lock()
                    loadedItems.append((index, pickedPhoto))
                    lock.unlock()
                }
            }

            group.notify(queue: .main) {
                let orderedItems = loadedItems
                    .sorted { $0.0 < $1.0 }
                    .map { $0.1 }
                guard orderedItems.isEmpty == false else {
                    return
                }
                self.parent.onPickedItems(orderedItems)
                if let first = orderedItems.first {
                    self.parent.onPicked(first.image, first.data)
                }
            }
        }
        
        private func loadPickedPhoto(
            from itemProvider: NSItemProvider,
            completion: @escaping (PickedPhoto?) -> Void
        ) {
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    if let data, let uiImage = UIImage(data: data) {
                        completion(
                            PickedPhoto(
                                image: Image(uiImage: uiImage),
                                data: data
                            )
                        )
                        return
                    }
                    self.loadUIImageFallback(from: itemProvider, completion: completion)
                }
                return
            }
            loadUIImageFallback(from: itemProvider, completion: completion)
        }

        private func loadUIImageFallback(
            from itemProvider: NSItemProvider,
            completion: @escaping (PickedPhoto?) -> Void
        ) {
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
                completion(nil)
                return
            }
            itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                guard let uiImage = object as? UIImage else {
                    completion(nil)
                    return
                }
                let data = uiImage.jpegData(compressionQuality: 0.9) ?? Data()
                completion(PickedPhoto(image: Image(uiImage: uiImage), data: data))
            }
        }
    }
}
