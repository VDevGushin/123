//
//  NewChat.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 01/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

class NewChat: Codable {
    let authorProfileId: Int
    var name: String
    let profileIds: [Int]

    init(name: String?, profileIds: [Int], authorProfileId: Int) {
        self.name = "Без названя"
        if let name = name, !name.isEmpty {
            self.name = name
        }
        self.profileIds = profileIds
        self.authorProfileId = authorProfileId
    }

    func encode() -> Data? {
        let encoder = ChatResources.encoder
        return try? encoder.encode(self)
    }
}
