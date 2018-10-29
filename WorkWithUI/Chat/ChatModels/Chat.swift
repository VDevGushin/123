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
    let id: Int
    let name: String?
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
}
