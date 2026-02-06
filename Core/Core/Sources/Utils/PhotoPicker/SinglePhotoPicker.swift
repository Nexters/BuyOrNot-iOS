//
//  SinglePhotoPicker.swift
//  Core
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI
import PhotosUI

public struct SinglePhotoPicker: UIViewControllerRepresentable {
    private let onPicked: (Image) -> Void
    
    public init(onPicked: @escaping (Image) -> Void) {
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
            
            guard let itemProvider = results.first?.itemProvider,
                  itemProvider.canLoadObject(ofClass: UIImage.self) else {
                return
            }
            
            itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                guard let uiImage = object as? UIImage else { return }
                DispatchQueue.main.async {
                    self.parent.onPicked(Image(uiImage: uiImage))
                }
            }
        }
    }
}
