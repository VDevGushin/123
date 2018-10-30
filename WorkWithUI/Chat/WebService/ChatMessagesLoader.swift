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
    private var source = [Message]()
    var sourceChanged = DelegatedCall<Result<[Message]>>()

    init(chatId: Int) { self.chatId = chatId }

    func refresh() {
        self.source.removeAll()
        self.page = 1
        self.getChatMessages()
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
                let messages: [Message] = try jsonData.decode(using: ChatResources.decoder)
                for i in 0..<messages.count {
                    wSelf.source.append(messages[i])
                }
                wSelf.sourceChanged.execute?(Result.result(wSelf.source.reversed()))
                wSelf.page += 1
            } catch {
                self?.sourceChanged.execute?(Result.error(error))
            }
        }
        task.resume()
    }

//    func getLast() {
//        let config = ETBChatWebConfigurator.getChatMessages(chatId: self.chatId, page: 1, perPage: self.perPage)
//        let request = ChatEndpoint(configurator: config).urlRequest()
//        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let wSelf = self else { return }
//
//            if let error = error {
//                self?.sourceChanged.execute?(Result.error(error))
//                return
//            }
//            guard let jsonData = data else {
//                self?.sourceChanged.execute?(Result.error(ChatsLoaderError.noData))
//                return
//            }
//            do {
//                let messages: Messages = try jsonData.decode(using: wSelf.decoder())
//                for i in 0..<messages.count {
//                    wSelf.source.insert(messages[i])
//                }
//                wSelf.sourceChanged.execute?(Result.result(wSelf.source))
//                wSelf.page += 1
//            } catch {
//                self?.sourceChanged.execute?(Result.error(error))
//            }
//        }
//        task.resume()
//    }
}
