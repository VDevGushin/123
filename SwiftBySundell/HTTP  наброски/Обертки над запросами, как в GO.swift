//
//  Request Behaviors.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 12/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit
/*При запуске сетевых запросов часто возникает много побочных эффектов.
Однако побочные эффекты являются ядом для тестируемости и могут варьироваться от приложения к приложению и от запроса к запросу.
Если мы сможем создать систему, в которой мы сможем создать и объединить эти побочные эффекты вместе, мы сможем повысить тестируемость и другие факторы.
Представьте себе очень простой сетевой клиент
*/

fileprivate struct Request {
    var request: URLRequest?
}

fileprivate final class NetworkClient {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func send(request: Request) -> Promise<Any> {
        let urlRequest = request.request!
        return Promise { [weak self] resolver in
            self?.session.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    if let error = error {
                        resolver.reject(error)
                    }
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data)
                        resolver.fulfill(json)
                    }
                    resolver.reject(PMKError.badInput)
                } catch {
                    resolver.reject(error)
                }
            }.resume()
        }
    }
}

// MARK: - RequestBehavior

fileprivate protocol RequestBehavior {
    var additionalHeaders: [String: String] { get }
    func beforeSend()
    func afterSuccess(result: Any)
    func afterFailure(error: Error)
}

extension RequestBehavior {
    var additionalHeaders: [String: String] {
        return [:]
    }

    func beforeSend() {
    }

    func afterSuccess(result: Any) {
    }

    func afterFailure(error: Error) {
    }
}

fileprivate struct EmptyRequestBehavior: RequestBehavior { }

fileprivate extension Dictionary {
    mutating func merge(with: [Key: Value]) {
        for (k, v) in with {
            updateValue(v, forKey: k)
        }
    }
}

fileprivate struct CombinedRequestBehavior: RequestBehavior {
    let behaviors: [RequestBehavior]

    var additionalHeaders: [String: String] {
        return behaviors.reduce([String: String](), { sum, behavior in
                var sum = sum
                sum.merge(with: behavior.additionalHeaders)
                return sum
            })
    }

    func beforeSend() {
        behaviors.forEach({ $0.beforeSend() })
    }

    func afterSuccess(result: Any) {
        behaviors.forEach({ $0.afterSuccess(result: result) })
    }

    func afterFailure(error: Error) {
        behaviors.forEach({ $0.afterFailure(error: error) })
    }
}

//NETwork with behaviors
fileprivate final class NetworkClient1 {
    private let session: URLSession
    private let defaultRequestBehavior: RequestBehavior

    init(session: URLSession = URLSession.shared, defaultRequestBehavior: RequestBehavior = EmptyRequestBehavior()) {
        self.session = session
        self.defaultRequestBehavior = defaultRequestBehavior
    }

    func send(request: Request, behavior: RequestBehavior = EmptyRequestBehavior()) -> Promise<Any> {
        let combinedBehavior = CombinedRequestBehavior(behaviors: [behavior, self.defaultRequestBehavior])

        let urlRequest = request.request!

        return Promise { [weak self] resolver in
            combinedBehavior.beforeSend()
            self?.session.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    if let error = error {
                        combinedBehavior.afterFailure(error: error)
                        resolver.reject(error)
                    }
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data)
                        combinedBehavior.afterSuccess(result: json)
                        resolver.fulfill(json)
                    }
                    combinedBehavior.afterFailure(error: PMKError.badInput)
                    resolver.reject(PMKError.badInput)
                } catch {
                    combinedBehavior.afterFailure(error: error)
                    resolver.reject(error)
                }
            }.resume()
        }
    }
}

//BackgroundTaskBehavior

fileprivate final class BackgroundTaskBehavior: RequestBehavior {
    private let application = UIApplication.shared
    private var identifier: UIBackgroundTaskIdentifier?

    func beforeSend() {
        identifier = application.beginBackgroundTask(expirationHandler: {
            self.endBackgroundTask()
        })
    }

    func afterSuccess(response: Any) {
        endBackgroundTask()
    }

    func afterFailure(error: Error) {
        endBackgroundTask()
    }

    private func endBackgroundTask() {
        if let identifier = identifier {
            application.endBackgroundTask(identifier)
            self.identifier = nil
        }
    }
}
