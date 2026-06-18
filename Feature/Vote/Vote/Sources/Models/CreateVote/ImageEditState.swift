//
//  ImageEditState.swift
//  Vote
//
//  Created by Codex on 6/18/26.
//

import SwiftUI

struct ImageEditState: Equatable {
    var rotationQuarterTurns: Int
    var cropAnchors: ImageCropAnchors?

    static let identity = ImageEditState()

    init(
        rotationQuarterTurns: Int = 0,
        cropAnchors: ImageCropAnchors? = nil
    ) {
        self.rotationQuarterTurns = Self.normalize(rotationQuarterTurns)
        self.cropAnchors = cropAnchors == .full ? nil : cropAnchors
    }

    static func normalize(_ quarterTurns: Int) -> Int {
        let remainder = quarterTurns % 4
        return remainder >= 0 ? remainder : remainder + 4
    }
}

struct ImageEditResult {
    let image: Image
    let data: Data
    let state: ImageEditState
}
