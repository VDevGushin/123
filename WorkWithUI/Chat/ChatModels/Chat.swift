//
//  Chat.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

typealias Chats = [Chat]

struct Chat: Decodable, Hashable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case authorProfileId = "author_profile_id"
        case isHidden = "is_hidden"
        case profileIds = "profile_ids"
        case deletedFor = "deleted_for"
        case lastMessage = "last_message"
        case createdAt = "created_at"
    }

    let id: Int
    let name: String?
    let createdAt: Date?
    let authorProfileId: Int?
    let isHidden: Bool?
    let profileIds: [Int]?
    let deletedFor: [Int]?
    let lastMessage: Message?

    var hashValue: Int {
        return self.id
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lastMessage = try container.decode(Message?.self, forKey: .lastMessage)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String?.self, forKey: .name)
        self.authorProfileId = try container.decode(Int?.self, forKey: .authorProfileId)
        self.isHidden = try container.decode(Bool?.self, forKey: .isHidden)
        self.profileIds = try container.decode([Int]?.self, forKey: .profileIds)
        self.deletedFor = try container.decode([Int]?.self, forKey: .deletedFor)
        self.createdAt = try container.decode(Date?.self, forKey: .createdAt)
    }
}
