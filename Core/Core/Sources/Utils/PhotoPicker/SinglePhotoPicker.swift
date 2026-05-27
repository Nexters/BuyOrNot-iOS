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
    private let onPicked: (Image, Data) -> Void
    
    public init(onPicked: @escaping (Image) -> Void) {
        self.onPicked = { image, _ in
            onPicked(image)
        }
    }
    
    public init(onPicked: @escaping (Image, Data) -> Void) {
        self.onPicked = onPicked
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        
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

            guard let firstResult = results.first else {
                return
            }
            
            loadPickedPhoto(from: firstResult.itemProvider) { pickedPhoto in
                guard let pickedPhoto else {
                    return
                }
                self.parent.onPicked(pickedPhoto.image, pickedPhoto.data)
            }
        }
        
        private func loadPickedPhoto(
            from itemProvider: NSItemProvider,
            completion: @escaping ((image: Image, data: Data)?) -> Void
        ) {
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    if let data, let uiImage = UIImage(data: data) {
                        completion((image: Image(uiImage: uiImage), data: data))
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
            completion: @escaping ((image: Image, data: Data)?) -> Void
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
                guard let data = uiImage.jpegData(compressionQuality: 0.9), data.isEmpty == false else {
                    completion(nil)
                    return
                }
                completion((image: Image(uiImage: uiImage), data: data))
            }
        }
    }
}
