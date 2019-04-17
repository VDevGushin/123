//
//  PowerOfResultTypes.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
// MARK: - help classes
fileprivate enum LoadingError: Error {
    case networkUnavailable
    case timedOut
    case invalidStatusCode(Int)
}

fileprivate struct User: Decodable {
    let name: String
    let age: Int
}

fileprivate enum Result<Value> {
    case success(Value)
    case failure(Error)

    func resolve()throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

extension Result where Value == Data {
    func decoded<T:Decodable>(_ decoder: JSONDecoder = .init()) throws -> T {
        let data = try self.resolve()
        return try decoder.decode(T.self, from: data)
    }
}


fileprivate func load(then handler: (Result<Data>) -> Void) {
    handler(.success(Data.init()))
}

//MARK: - Typed error
fileprivate enum ResultTypedError<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)

    func resolve()throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

extension ResultTypedError where Value == Data {
    func decoded<T:Decodable>(_ decoder: JSONDecoder = .init()) throws -> T {
        let data = try self.resolve()
        return try decoder.decode(T.self, from: data)
    }
}


fileprivate func loadWithTypedError(then handler: (ResultTypedError<Data?, LoadingError>) -> Void) {
    handler(.failure(.networkUnavailable))
}

fileprivate func test() {
    //try simple
    loadWithTypedError {
        switch $0 {
        case .success(let data):
            dump(data)
        case .failure(let error):
            switch error {
            case .invalidStatusCode: break
            case .networkUnavailable: break
            case .timedOut: break
            }
        }
    }

    //try resolve
    var result: (ResultTypedError<Data?, LoadingError>)?
    loadWithTypedError {
        result = $0
    }
    do {
        let _ = try result?.resolve()
    } catch {
        dump(error)
    }

    //try decodable
    load {
        do {
            let user = try $0.decoded() as User
            dump(user)
        } catch {

        }
    }
}
