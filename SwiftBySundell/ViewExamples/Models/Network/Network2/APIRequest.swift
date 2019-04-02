//
//  APIRequest.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 02/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?

    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }

    init<Body: Encodable>(method: HTTPMethod, path: String, body: Body, encoder: JSONEncoder = JSONEncoder()) throws {
        self.method = method
        self.path = path
        self.body = try encoder.encode(body)
    }
}
