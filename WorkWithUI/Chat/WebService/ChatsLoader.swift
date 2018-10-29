//
//  ChatsLoader.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class ChatsLoader {

    enum ChatsLoader: Error {
        case noData
        case decode
    }

    func getAllChats(then handler: @escaping (Result<Chats?>) -> Void) {
        let config = ETBChatWebConfigurator.getAllChatsConfigurator()
        let endpoint = ChatEndpoint(configurator: config)
        let request = endpoint.urlRequest()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { handler(Result.error(error)) }
            if let jsonData = data {
                do {
                    let chats = try JSONDecoder().decode(Chats.self, from: jsonData)
                    handler(Result.result(chats))
                } catch {
                    handler(Result.error(error))
                }
            }
            handler(Result.error(ChatsLoader.noData))
        }
        task.resume()
    }
}
