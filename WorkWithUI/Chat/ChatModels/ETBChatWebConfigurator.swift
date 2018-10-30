//
//  ETBChatWebConfigurator.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct ETBChatWebConfigurator {
    enum ChatComponents: String {
        case core
        case api
        case chats
        case messages

        var value: String {
            return self.rawValue
        }

        static func createPath(components: ChatComponents...) -> String {
            var pathStr = ""
            for i in 0..<components.count {
                pathStr += "/\(components[i].value)"
            }
            return pathStr
        }
    }

    let scheme: String
    let host: String
    let path: String
    let method: String
    let queryItems: [URLQueryItem]
    let header: [String: String]
    var body: Data?

    static func getAllChats() -> ETBChatWebConfigurator {
        let paths = ChatComponents.createPath(components: .core, .api, .chats)
        let queryItem = URLQueryItem(name: "pid", value: "\(ChatResources.pid)")
        let configurator = ETBChatWebConfigurator(scheme: "https", host: ChatResources.host, path: paths, method: "GET", queryItems: [queryItem], header: ChatResources.headers, body: nil)
        return configurator
    }

    static func getChatMessages(chatId: Int, page: Int, perPage: Int) -> ETBChatWebConfigurator {
        let paths = ChatComponents.createPath(components: .core, .api, .messages)
        let queryItemPid = URLQueryItem(name: "pid", value: "\(ChatResources.pid)")
        let queryItemChatId = URLQueryItem(name: "chat_id", value: "\(chatId)")
        let queryItemPage = URLQueryItem(name: "page", value: "\(page)")
        let queryItemPerPage = URLQueryItem(name: "per_page", value: "\(perPage)")
        let configurator = ETBChatWebConfigurator(scheme: "https", host: ChatResources.host, path: paths, method: "GET", queryItems: [queryItemPid, queryItemChatId, queryItemPage, queryItemPerPage], header: ChatResources.headers, body: nil)
        return configurator
    }

    static func postNew(message: NewMessage) -> ETBChatWebConfigurator? {
        guard let data = message.encode() else { return nil }
        let paths = ChatComponents.createPath(components: .core, .api, .messages)
        let queryItem = URLQueryItem(name: "pid", value: "\(ChatResources.pid)")
        let configurator = ETBChatWebConfigurator(scheme: "https", host: ChatResources.host, path: paths, method: "POST", queryItems: [queryItem], header: ChatResources.headers, body: data)
        return configurator
    }
}
