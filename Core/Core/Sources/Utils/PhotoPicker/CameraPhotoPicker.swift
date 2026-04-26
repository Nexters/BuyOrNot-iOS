//
//  CameraPhotoPicker.swift
//  Core
//
//  Created by Codex on 4/26/26.
//

import SwiftUI
import UIKit

public struct CameraPhotoPicker: UIViewControllerRepresentable {
    private let onPicked: (Image, Data) -> Void
    private let onCancel: () -> Void

    public init(
        onPicked: @escaping (Image, Data) -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        self.onPicked = onPicked
        self.onCancel = onCancel
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) { }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: CameraPhotoPicker

        init(_ parent: CameraPhotoPicker) {
            self.parent = parent
        }

        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel()
        }

        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            guard let image = info[.originalImage] as? UIImage else {
                parent.onCancel()
                return
            }
            let data = image.jpegData(compressionQuality: 0.9) ?? Data()
            parent.onPicked(Image(uiImage: image), data)
        }
    }
}
