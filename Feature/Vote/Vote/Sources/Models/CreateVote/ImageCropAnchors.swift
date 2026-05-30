//
//  ImageCropAnchors.swift
//  Vote
//
//  Created by 문종식 on 5/30/26.
//

import CoreGraphics

struct ImageCropAnchors: Equatable {
    var topLeft: CGPoint
    var topRight: CGPoint
    var bottomRight: CGPoint
    var bottomLeft: CGPoint

    static let full = ImageCropAnchors(
        topLeft: CGPoint(x: 0, y: 0),
        topRight: CGPoint(x: 1, y: 0),
        bottomRight: CGPoint(x: 1, y: 1),
        bottomLeft: CGPoint(x: 0, y: 1)
    )
}

extension ImageCropAnchors {
    var orderedNormalizedPoints: [CGPoint] {
        [topLeft, topRight, bottomRight, bottomLeft]
    }

    func projectedPoints(in rect: CGRect) -> [CGPoint] {
        orderedNormalizedPoints.map { normalized in
            CGPoint(
                x: rect.minX + rect.width * normalized.x,
                y: rect.minY + rect.height * normalized.y
            )
        }
    }
}
