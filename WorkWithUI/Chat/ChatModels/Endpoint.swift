//
//  Endpoint.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct ChatEndpoint {
    private let scheme: String
    private let host: String
    private let path: String
    private let method: String
    private let queryItems: [URLQueryItem]
    private let header: [String: String]

    private var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }


    func urlRequest() -> URLRequest {
        var request = URLRequest(url: self.url!)
        request.allHTTPHeaderFields = self.header
        request.httpMethod = self.method
        request.timeoutInterval = 30
        return request
    }

    init(configurator: ETBChatWebConfigurator) {
        self.scheme = configurator.scheme
        self.host = configurator.host
        self.path = configurator.path
        self.method = configurator.method
        self.queryItems = configurator.queryItems
        self.header = configurator.header
    }
}
