//
//  ImageCropMode.swift
//  Vote
//
//  Created by 문종식 on 5/30/26.
//

import DesignSystem

enum ImageCropMode: CaseIterable {
    case free
    case square
    case portrait3x4
    case landscape4x3
    
    var imageAsset: BNImageAsset {
        switch self {
        case .free:
            return .crop_free
        case .square:
            return .crop_square
        case .portrait3x4:
            return .crop_3_4
        case .landscape4x3:
            return .crop_4_3
        }
    }

    var title: String {
        switch self {
        case .free:
            return "자유형태"
        case .square:
            return "1:1"
        case .portrait3x4:
            return "3:4"
        case .landscape4x3:
            return "4:3"
        }
    }
}
