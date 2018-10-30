//
//  ChatMessagesLoader.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import SupportLib

final class ChatMessagesWorker {
    private let chatId: Int
    private var page = 1
    private var perPage = 1000
    private var isFirstTime = true
    var sourceChanged = DelegatedCall<Result<(isFirstTime: Bool, source: [Message])>>()

    init(chatId: Int) { self.chatId = chatId }

    func refresh() {
        self.page = 1
        self.isFirstTime = true
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
                wSelf.sourceChanged.execute?(Result.result((wSelf.isFirstTime, messages.reversed())))
                wSelf.isFirstTime = false
                if messages.count > 0 {
                    wSelf.page += 1
                }
            } catch {
                self?.sourceChanged.execute?(Result.error(error))
            }
        }
        task.resume()
    }

    func sendNewMessage(text: String?, then handler: @escaping (Result<Message>) -> Void) {
        guard let text = text, !text.isEmpty else { return }
        let new = NewMessage(text: text, chatId: chatId, readBy: [ChatResources.pid], attachmentIds: [])
        guard let config = ETBChatWebConfigurator.postNew(message: new) else { return }
        let request = ChatEndpoint(configurator: config).urlRequest()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(Result.error(error))
                return
            }
            guard let jsonData = data else {
                handler(Result.error(ChatsLoaderError.noData))
                return
            }
            do {
                let message: Message = try jsonData.decode(using: ChatResources.decoder)
                handler(Result.result(message))
            } catch {
                handler(Result.error(error))
            }
        }
        task.resume()
    }
}
