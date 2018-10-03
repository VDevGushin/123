//
//  Result.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case result(Value)
    case error(Error)
}

public extension Result {
    func resolve() throws -> Value {
        switch self {
        case .result(let value):
            return value
        case .error(let error):
            throw error
        }
    }
}

public extension Result where Value == Data {
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        let data = try resolve()
        return try decoder.decode(T.self, from: data)
    }
}
