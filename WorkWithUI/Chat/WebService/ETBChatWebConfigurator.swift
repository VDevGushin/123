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
        
        static func createPath(components: [ChatComponents]) -> String {
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
                "Auth-Token": "8a2a1b2f8a06f52db7316b289a59a803",
                "Profile-Id": "5787352",
                "User-Id": "5609724",
                "Content-Type": "application/json"
            ]
            return headers
        }
        let paths = ChatComponents.createPath(components: [.core, .api, .chats])
        let queryItem = URLQueryItem(name: "pid", value: "5787352")
        let configurator = ETBChatWebConfigurator(scheme: "https", host: "dnevnik.mos.ru", path: paths, method: "GET", queryItems: [queryItem], header: requiredHeaderMESH())
        return configurator
    }
}
