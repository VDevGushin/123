//
//  Message.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

typealias Messages = [Message]

struct Message: Decodable, Hashable, Equatable {
    let id: Int
    let chatId: Int
    let createdAt: Date?
    let fromProfileId: Int?
    let text: String?
    let isReported: Bool?
    let readBy: [Int]?
    let fromProfile: FromProfile?
    
    var hashValue: Int {
        return self.id ^ self.chatId
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

struct FromProfile: Decodable {
    let id: Int?
    let name: String?
}
