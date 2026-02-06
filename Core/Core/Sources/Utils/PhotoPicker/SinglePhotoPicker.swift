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
            
            guard let itemProvider = results.first?.itemProvider else {
                return
            }
            
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    if let data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.parent.onPicked(Image(uiImage: uiImage), data)
                        }
                        return
                    }
                    self.loadUIImageFallback(from: itemProvider)
                }
                return
            }
            
            loadUIImageFallback(from: itemProvider)
        }
        
        private func loadUIImageFallback(from itemProvider: NSItemProvider) {
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
            itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                guard let uiImage = object as? UIImage else { return }
                let data = uiImage.jpegData(compressionQuality: 0.9) ?? Data()
                DispatchQueue.main.async {
                    self.parent.onPicked(Image(uiImage: uiImage), data)
                }
            }
        }
    }
}
