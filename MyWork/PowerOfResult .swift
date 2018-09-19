//
//  PowerOfResult .swift
//  MyWork
//
//  Created by Vladislav Gushin on 28/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Simple result
enum PowerOfResult<Value> {
    case success(Value)
    case failure(Error)
}

// MARK: - Typed errors
enum TypedPowerOfResult<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

// MARK: Throwing
extension TypedPowerOfResult {
    func resolve() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    /*
     var result: Result<[SearchResult], SearchResultsLoader.Error>?
     loader.loadResults(matching: "query") {
     result = $0
     }
     let searchResults = try result?.resolve()
    */
}

// MARK: - Decoding
extension TypedPowerOfResult where Value == Data {
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        let data = try resolve()
        return try decoder.decode(T.self, from: data)
    }

    /*
     load { [weak self] result in
     do {
     let user = try result.decoded() as User
     self?.userDidLoad(user)
     } catch {
     self?.handle(error)
     }
     }
     */
}

// MARK: - Using
struct TestErrors {
    enum LoadingError: Error { }
    typealias Handler = (TypedPowerOfResult<Data, LoadingError>) -> Void

    func load(then handler: @escaping Handler) {
        //...
    }
}
