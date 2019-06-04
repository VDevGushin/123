//
//  BigImageDownloadConfigurator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct BigImageDownloadConfigurator: EndPointConfigurator {
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

    static func getBitImage(id: Int, filename: String) -> BigImageDownloadConfigurator {
        let path = BigImageDownloadComponents.createPath(components: .max, .id(id), .fileName(filename))

        let headers = [
            HTTPHeader(field: "Accept", value: "application/json"),
            HTTPHeader(field: "Accept-Encoding", value: "br, gzip, deflate")
        ]

        return BigImageDownloadConfigurator(scheme: "https",
            host: "cdn-images-1.medium.com",
            path: path,
            method: HTTPMethod.get,
            queryItems: nil,
            headers: headers,
            body: nil,
            multipartData: nil)
    }
}
