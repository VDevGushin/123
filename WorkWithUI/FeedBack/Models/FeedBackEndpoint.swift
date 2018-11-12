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
    private var multipart: [Data]? = nil

    private var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }

    typealias Item = (data: Data, mimeType: String, filename: String)

    func urlRequest() -> URLRequest {
        var request = URLRequest(url: self.url!)
        request.allHTTPHeaderFields = self.header
        request.httpMethod = self.method
        request.timeoutInterval = 30
        request.httpBody = self.body

        if let multipart = self.multipart {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let items = multipart.map { ($0, "image/jpg", "\(Int(Date().timeIntervalSince1970)).jpg") }
            request.httpBody = createBody(boundary: boundary, items: items)
        }
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
        self.multipart = configurator.multipartData
    }

    private func createBody(boundary: String, items: [Item]) -> Data {
        let body = NSMutableData()
        var counter = 1
        for item in items {
            let boundaryPrefix = "--\(boundary)\r\n"
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"file\(counter)\"; filename=\"\(item.filename)\"\r\n")
            body.appendString("Content-Type: \(item.mimeType)\r\n\r\n")
            body.append(item.data)
            body.appendString("\r\n")
            counter += 1
        }
        body.appendString("--".appending(boundary.appending("--")))
        return body as Data
    }
}

fileprivate extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
