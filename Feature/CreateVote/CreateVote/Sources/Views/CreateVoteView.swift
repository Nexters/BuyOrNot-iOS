//
//  PlaceHolder.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI
import DesignSystem

public struct CreateVoteView: View {
    @StateObject var viewModel = CreateVoteViewModel()
    @FocusState var priceFocused: Bool
    @FocusState var contentsFocused: Bool
    
    public init() {
        
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                cancel
                    .padding(.bottom, 14)
                Spacer()
            }
            .padding(.horizontal, 20)
            BNDivider(size: .s)
            VStack(spacing: 0) {
                category(viewModel.category)
                    .padding(.vertical, 18)
                BNDivider(size: .s)
                price
                BNDivider(size: .s)
                contents
                addPhoto
                Spacer()
                HStack {
                    Spacer()
                    BNButton(
                        text: "투표 게시!",
                        type: .capsule,
                        state: viewModel.createButtonState,
                        width: 80
                    ) {
                        
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            PhotoPicker { image in
                viewModel.didPickPendingImage(image)
            }
            .presentationDetents([.large])
            .presentationCornerRadius(18)
        }
        .onChange(of: viewModel.focusField) { oldValue, newValue in
            
        }
        .bnBottomSheet(
            isPresented: $viewModel.showCategoryBottomSheet,
            isEnableDismiss: true,
        ) { dismiss in
            CategorySheetView(
                viewModel.categories,
                viewModel.category
            ) { category in
                dismiss()
                viewModel.didChangeCategory(category)
                priceFocused = true
            }
        }
    }
    
    @ViewBuilder
    private var cancel: some View {
        Button {
            
        } label: {
            BNText("취소")
                .style(style: .s4sb, color: .type(.gray700))
        }
    }
    
    @ViewBuilder
    private func category(_ text: String?) -> some View {
        HStack(spacing: 8) {
            BNText("투표 등록")
                .style(style: .s3sb, color: .type(.gray800))
            BNImage(.right)
                .style(color: .type(.gray600), size: 14)
            Button {
                viewModel.showCategoryBottomSheet = true
                priceFocused = false
            } label: {
                if let text {
                    BNText(text)
                        .style(style: .s3sb, color: .type(.gray800))
                } else {
                    BNText("카테고리 추가")
                        .style(style: .s3sb, color: .type(.gray600))
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var price: some View {
        HStack(spacing: 6) {
            BNImage(.won)
                .style(color: .type(.gray600), size: 18)
            TextField(text: $viewModel.price) {
                BNText("상품 가격을 입력해주세요.")
                    .style(style: .s3sb, color: .type(.gray600))
            }
            .focused($priceFocused)
            .keyboardType(.numberPad)
            .font(BNFont.font(.s3sb))
            .foregroundStyle(BNColor(.type(.gray800)).color)
            .tint(BNColor(.type(.gray900)).color)
            .onChange(of: viewModel.price) { oldValue, newValue in
                viewModel.didChangePrice(previous: oldValue, text: newValue)
            }
            .onAppear {
                priceFocused = true
            }
            Spacer()
        }
        .frame(height: 18)
        .padding(.vertical, 18)
    }
    
    @ViewBuilder
    private var contents: some View {
        let placeHolder: String = "고민 이유를 자세히 적을수록 더 정확한 투표 결과를 얻을 수 있어요!"
        
        VStack(spacing: 0) {
            ZStack {
                if viewModel.contents.isEmpty {
                    VStack {
                        HStack {
                            BNText(placeHolder)
                                .style(style: .p2m, color: .type(.gray600))
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                TextField(
                    text: $viewModel.contents,
                    axis: .vertical
                ) {
                    
                }
                .font(BNFont.font(.p2m))
                .foregroundStyle(BNColor(.type(.gray900)).color)
                .tint(BNColor(.type(.gray900)).color)
                .focused($contentsFocused)
                .lineLimit(nil)
                .scrollContentBackground(.hidden)
                .frame(height: 84, alignment: .topLeading)
                .onChange(of: viewModel.contents) { oldValue, newValue in
                    viewModel.didChangeContents(text: newValue)
                }
            }
            .frame(height: 84)
            HStack {
                Spacer()
                BNText("\(viewModel.contents.count)/\(viewModel.contentsLimitCount)")
                    .style(style: .c1m, color: .type(.gray600))
            }
            .padding(.vertical, 10)
        }
        .padding(.top, 20)
        .onLongPressGesture(
            minimumDuration: .infinity,
            perform: {}
        ) { _ in
            viewModel.didTapContentsTextField()
        }
    }
    
    @ViewBuilder
    private var addPhoto: some View {
        HStack(spacing: 8) {
            Button {
                Task {
                    priceFocused = false
                    contentsFocused = false
                    await viewModel.checkPhotoPermission()
                }
            } label: {
                VStack(spacing: 2) {
                    BNImage(.camera)
                        .style(color: .type(.gray600), size: 20)
                    BNText("\(viewModel.selectedImage == nil ? 0 : 1)/1")
                        .style(style: .s5sb, color: .type(.gray600))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(BNColor(.type(.gray100)).color)
                }
            }
            if let image = viewModel.selectedImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 68, height: 68)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        HStack {
                            Spacer()
                            VStack {
                                Button {
                                    viewModel.didTapDeleteImage()
                                } label: {
                                    Circle()
                                        .fill(BNColor(.type(.black)).color.opacity(0.4))
                                        .overlay {
                                            BNImage(.close)
                                                .style(color: .type(.gray0), size: 10)
                                        }
                                        .frame(width: 20, height: 20)
                                        .padding(4)
                                }
                                Spacer()
                            }
                        }
                    }
            }
            Spacer()
        }
    }
}

#Preview {
    CreateVoteView()
}

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    let onPicked: (Image) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
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
