//
//  JSONExampleConfigurator.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 05/06/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct JSONExampleConfigurator: EndPointConfigurator {
    enum BigImageDownloadComponents: URLPathComponentBuilder {
        case max
        case id(Int)
        case fileName(String)

        var description: String {
            switch self {
            case .max:
                return "max"
            case .fileName(let name):
                return name
            case .id(let id):
                return "\(id)"
            }
        }
    }

    var scheme: String
    var host: String
    var path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    var multipartData: [Multipartable]?

    static func make() -> JSONExampleConfigurator {
        
        let headers = [
            HTTPHeader(field: "Accept", value: "application/json"),
            HTTPHeader(field: "Accept-Encoding", value: "br, gzip, deflate")
        ]
        
        return JSONExampleConfigurator(scheme: "http",
            host: "ip.jsontest.com",
            path: "",
            method: HTTPMethod.get,
            queryItems: nil,
            headers: headers,
            body: nil,
            multipartData: nil)
    }
}
