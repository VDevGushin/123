//
//  Message.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

typealias Messages = [Message]

struct Message: Codable, Hashable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case createdAt = "created_at"
        case fromProfileId = "from_profile_id"
        case text
        case isReported = "is_reported"
        case readBy = "read_by"
        case fromProfile = "from_profile"
    }

    let id: Int
    let chatId: Int
    let createdAt: Date
    let fromProfileId: Int
    var text: String? = nil
    var isReported: Bool? = nil
    var readBy: [Int]? = nil
    var fromProfile: Profile? = nil

    var hashValue: Int {
        return self.id ^ self.chatId ^ self.createdAt.hashValue ^ self.fromProfileId
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func isMy(checkId: Int) -> Bool {
        if let id = self.fromProfile?.id {
            return id == checkId
        }
        return false
    }

    func encode() -> Data? {
        let encoder = ChatResources.encoder
        return try? encoder.encode(self)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)


        self.id = try container.decode(Int.self, forKey: .id)
        self.chatId = try container.decode(Int.self, forKey: .chatId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.fromProfileId = try container.decode(Int.self, forKey: .fromProfileId)

        self.isReported = try? container.decode(Bool.self, forKey: .isReported)
        self.readBy = try? container.decode([Int].self, forKey: .readBy)
        self.fromProfile = try? container.decode(Profile.self, forKey: .fromProfile)
        self.text =  try? container.decode(String.self, forKey: .text)
    }
}
