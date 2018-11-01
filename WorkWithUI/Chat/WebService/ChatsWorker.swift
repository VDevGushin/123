//
//  ChatsLoader.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class ChatsWorker {
    func getAllChats(then handler: @escaping (Result<Chats>) -> Void) {
        let config = ETBChatWebConfigurator.getAllChats()
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
                let chats: Chats = try jsonData.decode(using:  ChatResources.decoder)
                handler(Result.result(chats.reversed()))
            } catch {
                handler(Result.error(error))
            }
        }
        task.resume()
    }
}
