//
//  URLSession+Ex.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 04/06/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

extension URLSession {
    static func makeDefaultSession(with configuration: URLSessionConfiguration = .default,
        cache: URLCache = .makePromiseCache()) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.httpMaximumConnectionsPerHost = 1
        return URLSession(configuration: configuration)
    }

    static func makeSession(with cacheBehavior: CacheBehavior?) -> URLSession {
        guard let cacheBehavior = cacheBehavior else {
            return URLSession.shared
        }
        return .makeDefaultSession(with: .default, cache: cacheBehavior.cache)
    }
}
