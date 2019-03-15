//
//  BigImageDownloadConfigurator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct BigImageDownloadConfigurator: RequestConfigurator {
    enum BigImageDownloadComponents {
        case max
        case id(Int)
        case fileName(String)

        var value: String {
            switch self {
            case .max:
                return "max"
            case .fileName(let name):
                return name
            case .id(let id):
                return "\(id)"
            }
        }

        static func createPath(components: BigImageDownloadComponents...) -> String {
            return components.map{ $0.value }.reduce(""){
                var old = $0
                old += "/\($1)"
                return old
            }
        }
    }

    var scheme: String
    var host: String
    var path: String
    var method: String
    var queryItems: [URLQueryItem]?
    var header: [String: String]?
    var body: Data?
    var multipartData: [Multipartable]?

    static func getBitImage(id: Int, filename: String) -> BigImageDownloadConfigurator {
        let path = BigImageDownloadComponents.createPath(components: .max, .id(id), .fileName(filename))

        let header = [
            "Accept": "application/json",
            "Accept-Encoding": " br, gzip, deflate"
        ]

        return BigImageDownloadConfigurator(scheme: "https",
                                            host: "cdn-images-1.medium.com",
                                            path: path,
                                            method: "GET",
                                            queryItems: nil,
                                            header: header,
                                            body: nil,
                                            multipartData: nil)
    }
}
