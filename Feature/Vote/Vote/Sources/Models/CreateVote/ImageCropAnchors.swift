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

    var minX: CGFloat { min(topLeft.x, bottomLeft.x) }
    var maxX: CGFloat { max(topRight.x, bottomRight.x) }
    var minY: CGFloat { min(topLeft.y, topRight.y) }
    var maxY: CGFloat { max(bottomLeft.y, bottomRight.y) }
    var width: CGFloat { maxX - minX }
    var height: CGFloat { maxY - minY }

    var center: CGPoint {
        CGPoint(x: (minX + maxX) / 2, y: (minY + maxY) / 2)
    }

    static func from(
        minX: CGFloat,
        maxX: CGFloat,
        minY: CGFloat,
        maxY: CGFloat
    ) -> ImageCropAnchors {
        ImageCropAnchors(
            topLeft: CGPoint(x: minX, y: minY),
            topRight: CGPoint(x: maxX, y: minY),
            bottomRight: CGPoint(x: maxX, y: maxY),
            bottomLeft: CGPoint(x: minX, y: maxY)
        )
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
