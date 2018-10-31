//
//  Profile.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

struct Profile: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case type
        case roles
    }

    let id: Int?
    let name: String?
    let status: String?
    let type: String?
    let roles: [String]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String?.self, forKey: .name)
        self.status = try container.decode(String?.self, forKey: .status)
        self.type = try container.decode(String?.self, forKey: .type)
        self.roles = try container.decode([String]?.self, forKey: .roles)
    }
}
