//
//  Organisation.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

typealias Organisations = [Organisation]

struct Organisation: Decodable, ISource {
    var innerTitle: String?
    var innerRaw: Any?

    let id: Int
    let address: String?
    let county: String?
    let shortTitle: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case address, county
        case shortTitle = "short_title"
        case title, id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.address = try? container.decode(String.self, forKey: .address)
        self.county = try? container.decode(String.self, forKey: .county)
        self.shortTitle = try? container.decode(String.self, forKey: .shortTitle)
        self.title = try? container.decode(String.self, forKey: .title)
        self.innerTitle = shortTitle
        self.innerRaw = self
    }
}
