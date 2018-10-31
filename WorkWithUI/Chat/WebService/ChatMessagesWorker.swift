//
//  ChatMessagesLoader.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import SupportLib

protocol MessagesWorkerDelegate: class {
    func sourceChanged(isFirstTime: Bool, source: Result<[Message]>)
    func receiveNewMessages(source: Result<[Message]>)
    func sourceCount(perPage: Int) -> Int
}

final class ChatMessagesWorker {
    weak var delegate: MessagesWorkerDelegate?
    private let chatId: Int
    private var perPage = 100
    private var page = 1
    private var isFirstTime = true
    private var isInLoading = false

    init(chatId: Int) { self.chatId = chatId }

    func refresh() {
        self.isFirstTime = true
        self.page = 1
        self.getChatMessages()
    }

    func startWork() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let wSelf = self else { return }
            if !wSelf.isInLoading {
                wSelf.getNewMessages()
            }
            wSelf.startWork()
        }
    }

    func getNewMessages() {
        self.isInLoading = true
        let config = ETBChatWebConfigurator.getChatMessages(chatId: self.chatId, page: 1, perPage: self.perPage)
        let request = ChatEndpoint(configurator: config).urlRequest()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let wSelf = self else { return }
            if let error = error {
                wSelf.delegate?.receiveNewMessages(source: Result.error(error))
                return
            }
            guard let jsonData = data else {
                wSelf.delegate?.receiveNewMessages(source: Result.error(ChatsLoaderError.noData))
                return
            }
            do {
                let messages: [Message] = try jsonData.decode(using: ChatResources.decoder)
                wSelf.delegate?.receiveNewMessages(source: Result.result(messages.reversed()))
            } catch {
                wSelf.delegate?.receiveNewMessages(source: Result.error(error))
            }
            wSelf.isInLoading = false
        }
        task.resume()
    }

    func getChatMessages() {
        guard let page = delegate?.sourceCount(perPage: self.perPage) else { return }
        self.isInLoading = true
        self.page = page
        let config = ETBChatWebConfigurator.getChatMessages(chatId: self.chatId, page: self.page, perPage: self.perPage)
        let request = ChatEndpoint(configurator: config).urlRequest()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let wSelf = self else { return }

            if let error = error {
                wSelf.delegate?.sourceChanged(isFirstTime: false, source: Result.error(error))
                return
            }
            guard let jsonData = data else {
                wSelf.delegate?.sourceChanged(isFirstTime: false, source: Result.error(ChatsLoaderError.noData))
                return
            }
            do {
                let messages: [Message] = try jsonData.decode(using: ChatResources.decoder)
                wSelf.delegate?.sourceChanged(isFirstTime: wSelf.isFirstTime, source: Result.result(messages.reversed()))
                wSelf.isFirstTime = false
            } catch {
                wSelf.delegate?.sourceChanged(isFirstTime: false, source: Result.error(error)) }
            
            wSelf.isInLoading = false
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
