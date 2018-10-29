//
//  ChatMessagesLoader.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import SupportLib

final class ChatMessagesLoader {
    private let chatId: Int
    private var page = 1
    private var perPage = 1000
    private var source = Set<Message>()
    var sourceChanged = DelegatedCall<Result<Set<Message>>>()

    init(chatId: Int) { self.chatId = chatId }

    func refresh() {
        self.source.removeAll()
        self.page = 1
        self.getChatMessages()
    }

    func getLastMessages() {
        self.getChatMessages(page: 1)
    }

    func getChatMessages(page: Int? = nil) {
        let config = ETBChatWebConfigurator.getChatMessages(chatId: self.chatId, page: page ?? self.page, perPage: self.perPage)
        let request = ChatEndpoint(configurator: config).urlRequest()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let wSelf = self else { return }

            if let error = error {
                self?.sourceChanged.execute?(Result.error(error))
                return
            }
            guard let jsonData = data else {
                self?.sourceChanged.execute?(Result.error(ChatsLoaderError.noData))
                return
            }
            do {
                let decoder = JSONDecoder.init()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
                formatter.dateFormat =  "dd.MM.yyyy HH:mm"
                decoder.dateDecodingStrategy = .formatted(formatter)
                let messages: Messages = try jsonData.decode(using: decoder)
                for i in 0..<messages.count {
                    wSelf.source.insert(messages[i])
                }
                wSelf.sourceChanged.execute?(Result.result(wSelf.source))
                wSelf.page += 1
            } catch {
                self?.sourceChanged.execute?(Result.error(error))
            }
        }
        task.resume()
    }
}
