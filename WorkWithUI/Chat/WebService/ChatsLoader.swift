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
    func getAllChats(then handler: @escaping (Result<Chats>) -> Void) {
        let config = ETBChatWebConfigurator.getAllChatsConfigurator()
        let endpoint = ChatEndpoint(configurator: config)
        let request = endpoint.urlRequest()
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
                let decoder = JSONDecoder.init()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
                formatter.dateFormat =  "dd.MM.yyyy HH:mm"
                decoder.dateDecodingStrategy = .formatted(formatter)
                let chats: Chats = try jsonData.decode(using: decoder)
                handler(Result.result(chats))
            } catch {
                handler(Result.error(error))
            }
        }
        task.resume()
    }
}
