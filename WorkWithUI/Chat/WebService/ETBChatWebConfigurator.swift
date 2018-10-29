//
//  ETBChatWebConfigurator.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct ETBChatWebConfigurator {
    static let authToken = "b88b3f699f6ddddfecf0310602ddd7ab"
    static let pid = "5787352"
    static let userid = "5609724"

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

    static func getAllChatsConfigurator() -> ETBChatWebConfigurator {
        func requiredHeaderMESH() -> [String: String] {
            let headers = [
                "Auth-Token": authToken,
                "Profile-Id": pid,
                "User-Id": userid,
                "Content-Type": "application/json"
            ]
            return headers
        }
        let paths = ChatComponents.createPath(components: .core, .api, .chats)
        let queryItem = URLQueryItem(name: "pid", value: pid)
        let configurator = ETBChatWebConfigurator(scheme: "https", host: "dnevnik.mos.ru", path: paths, method: "GET", queryItems: [queryItem], header: requiredHeaderMESH())
        return configurator
    }

    static func getChatMessages(chatId: Int, page: Int, perPage: Int) -> ETBChatWebConfigurator {
        func requiredHeaderMESH() -> [String: String] {
            let headers = [
                "Auth-Token": authToken,
                "Profile-Id": pid,
                "User-Id": userid,
                "Content-Type": "application/json"
            ]
            return headers
        }
        let paths = ChatComponents.createPath(components: .core, .api, .messages)
        let queryItemPid = URLQueryItem(name: "pid", value: pid)
        let queryItemChatId = URLQueryItem(name: "chat_id", value: "\(chatId)")
        let queryItemPage = URLQueryItem(name: "page", value: "\(page)")
        let queryItemPerPage = URLQueryItem(name: "per_page", value: "\(perPage)")
        let configurator = ETBChatWebConfigurator(scheme: "https", host: "dnevnik.mos.ru", path: paths, method: "GET", queryItems: [queryItemPid, queryItemChatId, queryItemPage, queryItemPerPage], header: requiredHeaderMESH())
        return configurator
    }
}
