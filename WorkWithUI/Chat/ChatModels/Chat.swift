//
//  Chat.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

typealias Chats = [Chat]

struct Chat: Decodable {
    enum CodingKey: String, Swift.CodingKey {
        case id
        case name
        case authorProfileId = "author_profile_id"
        case ishidden = "is_hidden"
        case profileIds = "profile_ids"
        case deletedFor = "deleted_for"
    }

    let id: Int
    let name: String?
    let authorProfileId: Int
    let ishidden: Bool
    let profileIds: [Int]?
    let deletedFor: [Int]?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKey.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String?.self, forKey: .name)
        self.authorProfileId = try values.decode(Int.self, forKey: .authorProfileId)
        self.ishidden = try values.decode(Bool.self, forKey: .ishidden)
        self.profileIds = try values.decode([Int]?.self, forKey: .profileIds)
        self.deletedFor = try values.decode([Int]?.self, forKey: .deletedFor)
        print("test")
    }

    static func makeChat(data: Data) -> Chat? {
        return try? JSONDecoder().decode(Chat.self, from: data)
    }

    static func makeChat(json: String) -> Chat? {
        if let jsonData = json.data(using: .utf8) {
            return try? JSONDecoder().decode(Chat.self, from: jsonData)
        }
        return nil
    }
}
