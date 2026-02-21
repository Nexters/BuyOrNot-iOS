//
//  UserResponse.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

struct UserResponse: Decodable {
    let id: Int
    let nickname: String
    let profileImage: String
    let socialAccount: String?
    let email: String?

    private enum CodingKeys: String, CodingKey {
        case id, userId, nickname, profileImage, socialAccount, email
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // 'id'로 시도해보고 없으면 'userId'로 파싱합니다.
        if let id = try? container.decode(Int.self, forKey: .id) {
            self.id = id
        } else {
            self.id = try container.decode(Int.self, forKey: .userId)
        }

        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImage = try container.decode(String.self, forKey: .profileImage)
        self.socialAccount = try container.decodeIfPresent(String.self, forKey: .socialAccount)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
    }
}
