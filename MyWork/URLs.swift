//
//  URLs.swift
//  MyWork
//
//  Created by Vladislav Gushin on 08/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//MARK: - String
fileprivate class URLSWork {
    func findRepositories(matching query: String) -> URL? {
        let api = "https://api.github.com"
        let endpoint = "/search/repositories?q=\(query)"
        let url = URL(string: api + endpoint)
        return url
    }
}

//MARK: - Components
fileprivate enum Sorting: String {
    case numberOfStars = "stars"
    case numberOfForks = "forks"
    case recency = "updated"
}

extension URLSWork {
    func findRepositories(matching query: String, sortedBy sorting: Sorting) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sorting.rawValue)
        ]
        let url = components.url
        return url
    }
}

//MARK: - Endpoints

fileprivate struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

extension Endpoint {
    static func search(matching query: String, sortedBy sorting: Sorting = .recency) -> Endpoint {
        return Endpoint(path: "/search/repositories", queryItems: [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sorting.rawValue)
        ])
    }
}

fileprivate enum E: Error {
    case t
}

fileprivate class DataLoaderWith {
    func request(_ endPoint: Endpoint, then handler: @escaping (Result<Data>) -> Void) {
        guard let url = endPoint.url else {
            return handler(Result.error(E.t))
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            let t = data.map{
//                return Result.result($0)       ===  data.map(Result.result)
//            }
            let result = data.map(Result.result) ?? .error(E.t)
            handler(result)
        }
        task.resume()
    }
}

//using
fileprivate class UsingDataLoaderWith {
    func test() {
        let dataLoader = DataLoaderWith()
        dataLoader.request(.search(matching: "1")) { result in

        }
    }
}
