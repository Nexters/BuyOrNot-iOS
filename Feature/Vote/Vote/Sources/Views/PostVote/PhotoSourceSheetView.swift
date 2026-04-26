//
//  PhotoSourceSheetView.swift
//  Vote
//
//  Created by Codex on 4/26/26.
//

import SwiftUI
import DesignSystem

struct PhotoSourceSheetView: View {
    let didTapCamera: () -> Void
    let didTapAlbum: () -> Void

    init(
        didTapCamera: @escaping () -> Void,
        didTapAlbum: @escaping () -> Void
    ) {
        self.didTapCamera = didTapCamera
        self.didTapAlbum = didTapAlbum
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Button {
                didTapCamera()
            } label: {
                HStack(spacing: 10) {
                    BNImage(.camera)
                        .style(color: ColorPalette.gray900, size: 20)
                    BNText("카메라로 직접 찍기")
                        .style(style: .s3sb, color: ColorPalette.gray900)
                    Spacer()
                }
                .padding(.vertical, 5)
            }

            Button {
                didTapAlbum()
            } label: {
                HStack(spacing: 10) {
                    BNImage(.photo_album)
                        .style(color: ColorPalette.gray900, size: 20)
                    BNText("앨범에서 사진 선택")
                        .style(style: .s3sb, color: ColorPalette.gray900)
                    Spacer()
                }
                .padding(.vertical, 5)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
}

#Preview {
    PhotoSourceSheetView(
        didTapCamera: {},
        didTapAlbum: {}
    )
}
