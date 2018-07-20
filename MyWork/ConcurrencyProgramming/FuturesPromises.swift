//
//  FuturesPromises.swift
//  MyWork
//
//  Created by Vladislav Gushin on 19/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import Unbox

//https://github.com/mxcl/PromiseKit
//https://github.com/Thomvis/BrightFutures
//https://github.com/vadymmarkov/When
//https://github.com/freshOS/then
//Простой пример загрузки
protocol Savable {
}

class DataBase<T> {
    func save(user: T, completion: (T) -> Void) {

    }
}

fileprivate class UserLoader {
    typealias Handler = (Result<User>) -> Void
    let dataBase = DataBase<User>()

    func loadUser(withID id: Int, completionHandler: @escaping Handler) {
        let url = URL(string: "\(id)")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                completionHandler(.error(error))
            } else {
                do {
                    let user: User = try unbox(data: data ?? Data())
                    self?.dataBase.save(user: user) {
                        completionHandler(.result($0))
                    }
                } catch {
                    completionHandler(.error(error))
                }
            }
        }
        task.resume()
    }
}

////Использование функционала futures and promise
//class UserLoader {
//    func loadUser(withID id: Int) -> Future<User> {
//        let url = apiConfiguration.urlForLoadingUser(withID: id)
//
//        return urlSession.request(url: url)
//            .unboxed()
//            .saved(in: database)
//    }
//}
//let userLoader = UserLoader()
//userLoader.loadUser(withID: userID).observe { result in
//    // Handle result
//}

//В будущем мы делаем выбор сдерживать обещание или нет
fileprivate class Future<Value> {
    private lazy var callbacks = [(Result<Value>) -> Void]()
    fileprivate var result: Result<Value>? {
        didSet {
            result.map(report)
        }
    }

    func observe(with callback: @escaping (Result<Value>) -> Void) {
        self.callbacks.append(callback)
        result.map(callback)
    }

    private func report(result: Result<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }


    func chained<NextValue>(with closure: @escaping (Value) throws -> Future<NextValue>) -> Future<NextValue> {
        let promise = Promise<NextValue>()
        self.observe { result in
            switch result {
            case .error(let error):
                promise.reject(with: error)
            case .result(let value):
                do {
                    let future = try closure(value)
                    future.observe { result in
                        switch result {
                        case .result(let value):
                            promise.resolve(with: value)
                        case .error(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            }
        }
        return promise
    }
}

extension Future where Value: Savable {
    func saved(in database: DataBase<Value>) -> Future<Value> {
        return chained { user in
            let promise = Promise<Value>()

            database.save(user: user) { user in
                promise.resolve(with: user)
            }

            return promise
        }
    }
}

//Обещание, которое мы даем кому то (МЫ это будем делать точно, но вот результат может быть любой. В нашем случан succes/error)
fileprivate class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()
        result = value.map(Result.result)
    }

    func resolve(with value: Value) {
        result = .result(value)
    }

    func reject(with error: Error) {
        result = .error(error)
    }
}
//Расширение на сессию для поддеркжки futures and promiseI
fileprivate extension URLSession {
    func request(url: URL) -> Future<Data> {
        let promise = Promise<Data>()
        let task = dataTask(with: url) { data, _, error in
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }
        task.resume()
        return promise
    }
}

//пример использования
fileprivate  class TestFuturePromise {
    func test() {
        URLSession.shared.request(url: URL(string: "TestStringURL")!).observe { result in

        }
    }
}
