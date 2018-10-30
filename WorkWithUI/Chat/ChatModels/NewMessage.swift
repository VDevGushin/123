//
//  NewMessage.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

struct NewMessage: Encodable {
    let text: String?
    let chatId: Int
    let readBy: [Int]?
    let attachmentIds: [Int]?
    init(text: String?, chatId: Int, readBy: [Int]?, attachmentIds: [Int]?) {
        self.text = text
        self.chatId = chatId
        self.readBy = readBy
        self.attachmentIds = attachmentIds
    }
    
    func encode() -> Data? {
        let encoder = ChatResources.encoder
        return try? encoder.encode(self)
    }
}
