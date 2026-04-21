//
//  FeedCategory.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

public enum FeedCategory: String, CaseIterable {
    case luxury = "LUXURY"
    case fashion = "FASHION"
    case beauty = "BEAUTY"
    case food = "FOOD"
    case electronics = "ELECTRONICS"
    case travel = "TRAVEL"
    case health = "HEALTH"
    case book = "BOOK"
    case etc = "ETC"

    public var displayName: String {
        switch self {
        case .luxury:
            return "명품 ∙ 프리미엄"
        case .fashion:
            return "패션 ∙ 잡화"
        case .beauty:
            return "화장품 ∙ 뷰티"
        case .food:
            return "음식"
        case .electronics:
            return "전자기기"
        case .travel:
            return "여행 쇼핑템"
        case .health:
            return "헬스 ∙ 운동용품"
        case .book:
            return "도서"
        case .etc:
            return "기타"
        }
    }
}
