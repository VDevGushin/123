//
//  FeedBackWebConfigurator.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

struct FeedBackWebConfigurator {
    enum FeedBackComponents: String {
        case argus
        case api
        case captcha

        var value: String {
            return self.rawValue
        }

        static func createPath(components: FeedBackComponents...) -> String {
            var pathStr = ""
            for i in 0..<components.count {
                pathStr += "/\(components[i].value)"
            }
            return pathStr
        }
    }

    let scheme: String
    let host: String
    let path: String
    let method: String
    let queryItems: [URLQueryItem]?
    let header: [String: String]?
    var body: Data?

    static func getCaptcha() -> FeedBackWebConfigurator {
        let paths = FeedBackComponents.createPath(components: .argus, .api, .captcha)
        let header = [
            "Accept": "application/json",
            "Accept-Encoding": " br, gzip, deflate"
        ]
        let configurator = FeedBackWebConfigurator(scheme: "https", host: FeedBackConfig.host, path: paths, method: "GET", queryItems: nil, header: header, body: nil)
        return configurator
    }
}
