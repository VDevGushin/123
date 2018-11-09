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
        case school_dictionaries
        case schools
        case tickets
        case categories
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

    static func getOrganisations(page: Int, perPage: Int) -> FeedBackWebConfigurator {
        let paths = FeedBackComponents.createPath(components: .argus, .api, .school_dictionaries, .schools)
        let header = [
            "Accept": "application/json",
            "Accept-Encoding": " br, gzip, deflate"
        ]
        let queryItemPage = URLQueryItem(name: "page", value: "\(page)")
        let queryItemPerPage = URLQueryItem(name: "per_page", value: "\(perPage)")
        let configurator = FeedBackWebConfigurator(scheme: "https", host: FeedBackConfig.host, path: paths, method: "GET", queryItems: [queryItemPage, queryItemPerPage], header: header, body: nil)
        return configurator
    }


    static func getThemes() -> FeedBackWebConfigurator {
        let paths = FeedBackComponents.createPath(components: .argus, .api, .tickets, .categories)
        let header = [
            "Accept": "application/json",
            "Accept-Encoding": " br, gzip, deflate"
        ]
        let configurator = FeedBackWebConfigurator(scheme: "https", host: FeedBackConfig.host, path: paths, method: "GET", queryItems: nil, header: header, body: nil)
        return configurator
    }

    static func sendFeedBack(captchaId: String, captchaValue: String, data: Data) -> FeedBackWebConfigurator {
        let paths = FeedBackComponents.createPath(components: .argus, .api, .tickets)
        let header = [
            "Accept": "application/json",
            "Accept-Encoding": " br, gzip, deflate"
        ]

        let q1 = URLQueryItem(name: "captcha_id", value: "\(captchaId)")
        let q2 = URLQueryItem(name: "captcha_value", value: "\(captchaValue)")

        let configurator = FeedBackWebConfigurator(scheme: "https", host: FeedBackConfig.host, path: paths, method: "POST", queryItems: [q1, q2], header: header, body: data)
        return configurator
    }
}
