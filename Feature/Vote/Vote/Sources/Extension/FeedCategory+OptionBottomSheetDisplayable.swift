//
//  FeedCategory+OptionBottomSheetDisplayable.swift
//  Vote
//
//  Created by 문종식 on 4/28/26.
//

import DesignSystem
import Domain

extension FeedCategory: OptionBottomSheetDisplayable {
    public var title: String { displayName }
}
