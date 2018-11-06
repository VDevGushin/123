//
//  FeedBackEndpoint.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

struct FeedBackEndpoint {
    private let scheme: String
    private let host: String
    private let path: String
    private let method: String
    private let queryItems: [URLQueryItem]?
    private let header: [String: String]?
    private var body: Data? = nil
    
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
        request.httpBody = self.body
        return request
    }
    
    init(configurator: FeedBackWebConfigurator) {
        self.scheme = configurator.scheme
        self.host = configurator.host
        self.path = configurator.path
        self.method = configurator.method
        self.queryItems = configurator.queryItems
        self.header = configurator.header
        self.body = configurator.body
    }
}
