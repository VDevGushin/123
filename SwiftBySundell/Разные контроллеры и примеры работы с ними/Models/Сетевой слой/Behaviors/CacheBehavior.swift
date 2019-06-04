//
//  CacheBehavior.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 04/06/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

class CacheBehavior: WebRequestBehavior {
    let cache: URLCache
    init(cache: URLCache) {
        self.cache = cache
    }

    func modify(request: URLRequest,
        acceptedResponse: HTTPRequest.Response) -> HTTPRequest.Response {

        //Verify that we need to use the cache
        if let httpResponse = acceptedResponse.response as? HTTPURLResponse,
            200 ... 299 ~= httpResponse.statusCode {
            return acceptedResponse
        }

        // Get the response
        guard let cachedResponse = self.cache.cachedResponse(for: request),
            let httpURLResponse = cachedResponse.response as? HTTPURLResponse else {
                return acceptedResponse
        }

        var date: Date?
        if let userInfo = cachedResponse.userInfo,
            let cacheDate = userInfo["saveDate"] as? TimeInterval {
            date = Date(timeIntervalSince1970: cacheDate)
        }
        
        return HTTPRequest.Response(data: cachedResponse.data, response: httpURLResponse, date: date)
    }
}

