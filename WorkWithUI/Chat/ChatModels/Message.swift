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
    let id: Int
    let chatId: Int
    let createdAt: Date
    let fromProfileId: Int
    let text: String?
    let isReported: Bool?
    let readBy: [Int]?
    let fromProfile: Profile?
    
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
}
