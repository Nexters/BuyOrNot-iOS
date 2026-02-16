//
//  FeedCategory.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

public enum FeedCategory: String {
    case luxury = "LUXURY"
    case fashion = "FASHION"
    case beauty = "BEAUTY"
    case food = "FOOD"
    case electronics = "ELECTRONICS"
    case travel = "TRAVEL"
    case health = "HEALTH"
    case book = "BOOK"
    case etc = "ETC"
    
    public init(rawValue: String) {
        switch rawValue {
        case "LUXURY":
            self = .luxury
        case "FASHION":
            self = .fashion
        case "BEAUTY":
            self = .beauty
        case "FOOD":
            self = .food
        case "ELECTRONICS":
            self = .electronics
        case "TRAVEL":
            self = .travel
        case "HEALTH":
            self = .health
        case "BOOK":
            self = .book
        case "ETC":
            self = .etc
        default:
            self = .etc
        }
    
    }
}
