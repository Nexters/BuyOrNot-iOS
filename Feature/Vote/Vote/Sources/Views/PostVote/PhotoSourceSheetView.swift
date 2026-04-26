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
        VStack(alignment: .leading, spacing: 0) {
            BNText("사진 등록")
                .style(style: .s1sb, color: ColorPalette.gray950)
                .padding(.bottom, 8)

            Button {
                didTapCamera()
            } label: {
                HStack {
                    BNText("카메라로 직접 찍기")
                        .style(style: .s3sb, color: ColorPalette.gray900)
                    Spacer()
                }
                .padding(.vertical, 16)
            }

            BNDivider(size: .s)

            Button {
                didTapAlbum()
            } label: {
                HStack {
                    BNText("앨범에서 사진 선택")
                        .style(style: .s3sb, color: ColorPalette.gray900)
                    Spacer()
                }
                .padding(.vertical, 16)
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
