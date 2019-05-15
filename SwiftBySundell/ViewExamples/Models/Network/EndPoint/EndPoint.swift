//
//  EndPoint.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

protocol EndPoint {
    var timeoutInterval: TimeInterval { get set }
    var configurator: EndPointConfigurator { get }
    func makeURLRequest() throws -> URLRequest
}

extension EndPoint {
    func makeURLRequest() throws -> URLRequest {
        guard let url = self.url else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.configurator.headers?.convertToDictionary()
        request.httpMethod = self.configurator.method.description
        request.timeoutInterval = self.timeoutInterval
        request.httpBody = self.configurator.body

        if let multipart = self.configurator.multipartData {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createBody(boundary: boundary, items: multipart)
        }

        return request
    }
}

// MARK: - Private
fileprivate extension EndPoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = self.configurator.scheme
        components.host = self.configurator.host
        components.path = self.configurator.path
        components.queryItems = self.configurator.queryItems
        return components.url
    }

    func createBody(boundary: String, items: [Multipartable]) -> Data {
        let body = NSMutableData()
        for index in 1...items.count {
            let item = items[index - 1]
            let boundaryPrefix = "--\(boundary)\r\n"
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"file\(index)\"; filename=\"\(item.fileName)\"\r\n")
            body.appendString("Content-Type: \(item.mimeType)\r\n\r\n")
            body.append(item.data)
            body.appendString("\r\n")
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
