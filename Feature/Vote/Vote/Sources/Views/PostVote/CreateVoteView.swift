//
//  PlaceHolder.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI
import UIKit
import Core
import DesignSystem
import Domain

public struct CreateVoteView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: CreateVoteViewModel
    @FocusState private var focusState: FocusedTextField?
    
    public init(viewModel: CreateVoteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        category(viewModel.category)
                            .padding(.vertical, 18)
                        BNDivider(size: .s)
                        link
                        BNDivider(size: .s)
                        price
                        BNDivider(size: .s)
                        title
                        contents
                        addPhoto
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                VStack(spacing: 10) {
                    Spacer()
                    if viewModel.snackBar.barState == .active {
                        BNSnackBar(
                            item: viewModel.snackBar.currentItem,
                            state: $viewModel.snackBar.barState
                        )
                    }
                    HStack(spacing: 6) {
                        if viewModel.isKeyboardVisible {
                            subAddPhoto
                        }
                        Spacer()
                        if viewModel.createButtonState == .enabled && !viewModel.isKeyboardVisible {
                            VotePostTooltip()
                        }
                        BNButton(
                            text: "투표 게시!",
                            type: .capsule,
                            state: viewModel.createButtonState,
                            width: 80
                        ) {
                            Task {
                                guard viewModel.validateLinkURLBeforePost() else {
                                    return
                                }
                                let result = await viewModel.postVote()
                                if result {
                                    dismiss()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            let shouldShowRestoreAlert = viewModel.checkPendingVoteCreateInfoOnAppear()
            self.focusState = shouldShowRestoreAlert ? nil : .price
        }
        .onChange(of: viewModel.showRestorePendingAlert) { _, isPresented in
            if isPresented {
                focusState = nil
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            viewModel.keyboardWillShow()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            viewModel.keyboardWillHide()
        }
        .interactiveDismissDisabled(true)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            SinglePhotoPicker(
                selectionLimit: max(1, viewModel.remainingSelectablePhotoCount)
            ) { photos in
                viewModel.didSelectPhotos(photos)
            }
            .presentationDetents([.large])
            .presentationCornerRadius(18)
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
            }
        }
        .bnAlert(
            isPresented: $viewModel.showCustomAlert,
            isEnableDismiss: true,
            config: BNAlertConfig(
                title: "사진 접근 권한을 허용해주세요",
                message: "더 쉽고 편하게 사진을 올릴 수 있어요.",
                buttons: [
                    .close,
                    BNAlertButtonConfig(
                        text: "접근 허용하기",
                        type: .primary,
                    ) {
                        viewModel.openPhotoAuthorizationSetting()
                    },
                ]
            )
        )
        .bnAlert(
            isPresented: $viewModel.showCancelAlert,
            isEnableDismiss: true,
            config: BNAlertConfig(
                title: "다음에 등록할까요?",
                message: "지금까지 쓴 내용은 저장되지 않아요.",
                buttons: [
                    BNAlertButtonConfig(
                        text: "나가기",
                        type: .secondaryLarge
                    ) {
                        viewModel.removePendingVoteCreateInfo()
                        dismiss()
                    },
                    BNAlertButtonConfig(
                        text: "유지하기",
                        type: .primary
                    ) { }
                ]
            )
        )
        .bnAlert(
            isPresented: $viewModel.showRestorePendingAlert,
            isEnableDismiss: true,
            config: BNAlertConfig(
                title: "이전에 작성하던 글이 있어요!",
                message: "[닫기] 선택 시 해당 내용은 복구할 수 없어요.",
                buttons: [
                    .close,
                    BNAlertButtonConfig(
                        text: "불러오기",
                        type: .primary
                    ) {
                        viewModel.restorePendingVoteCreateInfo()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            focusState = .price
                        }
                    }
                ]
            )
        )
    }
    
    @ViewBuilder
    private var cancel: some View {
        Button {
            if viewModel.isWritingInProgress {
                viewModel.didTapCancel()
            } else {
                dismiss()
            }
        } label: {
            BNText("취소")
                .style(style: .s4sb, color: ColorPalette.gray700)
        }
    }
    
    @ViewBuilder
    private func category(_ selectedCategory: FeedCategory?) -> some View {
        HStack(spacing: 8) {
            BNText("투표 등록")
                .style(style: .s3sb, color: ColorPalette.gray800)
            BNImage(.right)
                .style(color: ColorPalette.gray600, size: 14)
            Button {
                viewModel.showCategoryBottomSheet = true
            } label: {
                if let selectedCategory {
                    BNText(selectedCategory.displayName)
                        .style(style: .s3sb, color: ColorPalette.gray800)
                } else {
                    BNText("카테고리 추가")
                        .style(style: .s3sb, color: ColorPalette.gray600)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var link: some View {
        HStack(spacing: 6) {
            BNImage(.link)
                .style(color: ColorPalette.gray600, size: 18)
            ZStack(alignment: .leading) {
                if viewModel.linkURL.isEmpty {
                    HStack(spacing: 2) {
                        BNText("상품 링크")
                            .style(style: .s3sb, color: ColorPalette.gray600)
                        BNText("(선택)")
                            .style(style: .s5sb, color: ColorPalette.gray600)
                    }
                    .allowsHitTesting(false)
                }
                TextField("", text: $viewModel.linkURL)
                    .focused($focusState, equals: .link)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .font(.s3sb)
                    .foregroundStyle(ColorPalette.gray800)
                    .tint(ColorPalette.gray950)
                    .onChange(of: viewModel.linkURL) { _, _ in
                        viewModel.didChangeLinkURL()
                    }
            }
            Spacer()
        }
        .frame(height: 18)
        .padding(.vertical, 18)
        .onTapGesture {
            focusState = .link
        }
    }
    
    @ViewBuilder
    private var price: some View {
        HStack(spacing: 6) {
            BNImage(.won)
                .style(color: ColorPalette.gray600, size: 18)
            TextField(text: $viewModel.price) {
                BNText("상품 가격")
                    .style(style: .s3sb, color: ColorPalette.gray600)
            }
            .focused($focusState, equals: .price)
            .keyboardType(.numberPad)
            .font(.s3sb)
            .foregroundStyle(ColorPalette.gray800)
            .tint(ColorPalette.gray950)
            .onChange(of: viewModel.price) { oldValue, newValue in
                viewModel.didChangePrice(previous: oldValue, text: newValue)
            }
            Spacer()
        }
        .frame(height: 18)
        .padding(.vertical, 18)
        .onTapGesture {
            focusState = .price
        }
    }
    
    @ViewBuilder
    private var title: some View {
        TextField(text: $viewModel.title) {
            BNText("제목")
                .style(style: .t2b, color: ColorPalette.gray600)
        }
        .focused($focusState, equals: .title)
        .lineLimit(1)
        .font(.t2b)
        .foregroundStyle(ColorPalette.gray950)
        .tint(ColorPalette.gray950)
        .padding(.top, 20)
        .onChange(of: viewModel.title) { _, newValue in
            viewModel.didChangeTitle(text: newValue)
        }
        .onTapGesture {
            focusState = .title
        }
    }
    
    @ViewBuilder
    private var contents: some View {
        VStack(spacing: 0) {
            TextField(
                "",
                text: $viewModel.contents,
                axis: .vertical
            )
            .font(.p2m)
            .foregroundStyle(ColorPalette.gray950)
            .tint(ColorPalette.gray950)
            .focused($focusState, equals: .contents)
            .lineLimit(nil)
            .scrollContentBackground(.hidden)
            .frame(height: 84, alignment: .topLeading)
            .onChange(of: viewModel.contents) { oldValue, newValue in
                viewModel.didChangeContents(text: newValue)
            }
            .overlay {
                if viewModel.contents.isEmpty {
                    VStack {
                        HStack {
                            BNText("고민 이유를 자세히 적을수록 더 정확한 투표 결과를 얻을 수 있어요!")
                                .style(style: .p2m, color: ColorPalette.gray600)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .frame(height: 84)
            HStack {
                Spacer()
                BNText("\(viewModel.contents.count)/\(viewModel.contentsLimitCount)")
                    .style(style: .c1m, color: ColorPalette.gray600)
            }
            .padding(.vertical, 10)
        }
        .padding(.top, 12)
        .background(.white)
        .onTapGesture {
            focusState = .contents
        }
    }
    
    @ViewBuilder
    private var addPhoto: some View {
        HStack(spacing: 8) {
            Button {
                Task {
                    await viewModel.checkPhotoPermission()
                }
            } label: {
                VStack(spacing: 2) {
                    BNImage(.camera)
                        .style(color: ColorPalette.gray600, size: 20)
                    BNText("\(viewModel.selectedPhotoCount)/3")
                        .style(style: .s5sb, color: ColorPalette.gray600)
                }
                .frame(width: 68, height: 68)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorPalette.gray100)
                }
            }
            .disabled(viewModel.isPhotoPickerEnabled == false)

            ForEach(Array(viewModel.selectedPhotos.enumerated()), id: \.offset) { index, photo in
                photo.image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 68, height: 68)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        HStack {
                            Spacer()
                            VStack {
                                Button {
                                    viewModel.didTapDeleteImage(at: index)
                                } label: {
                                    Circle()
                                        .fill(ColorPalette.black.opacity(0.4))
                                        .overlay {
                                            BNImage(.close)
                                                .style(color: ColorPalette.gray0, size: 10)
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
    
    @ViewBuilder
    private var subAddPhoto: some View {
        Button {
            Task {
                await viewModel.checkPhotoPermission()
            }
        } label: {
            HStack(spacing: 4) {
                BNImage(.camera)
                    .style(color: ColorPalette.gray950, size: 20)
                BNText("\(viewModel.selectedPhotoCount)/3")
                    .style(style: .s5sb, color: ColorPalette.gray800)
            }
        }
    }
}


// MARK: - Preview

private struct MockUploadsRepository: UploadsRepository {
    func postUploadImage(data: Data, fileName: String, contentType: String) async throws -> ImageInfo {
        ImageInfo(uploadUrl: "", s3ObjectKey: "mock", viewUrl: "")
    }
}

private struct MockFeedRepository: FeedRepository {
    func getVoteFeeds(cursor: Int?, size: Int, feedStatus: String?) async throws -> VotePage {
        VotePage(votes: [], nextCursor: nil, hasNext: false)
    }
    func getMyVoteFeeds(cursor: Int?, size: Int, feedStatus: String?) async throws -> VotePage {
        VotePage(votes: [], nextCursor: nil, hasNext: false)
    }
    func postVoteFeed(info: VoteCreateInfo) async throws -> Int { 0 }
    func voteFeed(feedId: Int, choice: VoteChoice) async throws -> VoteResult {
        VoteResult(feedId: feedId, choice: choice, yesCount: 0, noCount: 0, totalCount: 0)
    }
    func reportVoteFeed(feedId: Int) async throws {}
    func deleteVoteFeed(feedId: Int) async throws {}
    func getFeedDetail(feedId: Int) async throws -> Vote {
        Vote(
            feedId: feedId,
            content: "",
            price: 0,
            category: .etc,
            yesCount: 0,
            noCount: 0,
            voteStatus: .open,
            s3ObjectKey: "",
            viewUrl: "",
            imageWidth: 0,
            imageHeight: 0,
            author: FeedAuthor(id: 0, nickname: "", profileImage: ""),
            createdAt: DateComponents(),
            hasVoted: false,
            myVoteChoice: nil
        )
    }
}

private struct MockPendingVoteCreateInfoRepository: PendingVoteCreateInfoRepository {
    func savePendingVoteCreateInfo(_ info: PendingVoteCreateInfo) {}
    func getPendingVoteCreateInfo() -> PendingVoteCreateInfo? { nil }
    func removePendingVoteCreateInfo() {}
}

#Preview {
    CreateVoteView(
        viewModel: CreateVoteViewModel(
            uploadsRepository: MockUploadsRepository(),
            feedRepository: MockFeedRepository(),
            pendingVoteCreateInfoRepository: MockPendingVoteCreateInfoRepository()
        )
    )
}
