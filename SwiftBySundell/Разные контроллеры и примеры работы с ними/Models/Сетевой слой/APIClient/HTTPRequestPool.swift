//
//  HTTPRequestPool.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 31/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

final class HTTPRequestPool {
    static let shared = HTTPRequestPool()
    private let queue = DispatchQueue(label: "HTTPRequestPool.thread", attributes: .concurrent)
    private var requests: [Int: HTTPRequest] = [:]

    var count: Int { return self.requests.count }

    private init() { }

    /**
 Создание сущности запроса.
 - Parameter name: Название запроса для его идентификации при удалении
 - Parameter endPoint: EndPoint сети
 - Parameter requestBahaviors: Разные прослойки для вызова в разных метсах при выполнении запросов
 - Returns: Возвращает либо готовый HTTPRequest либо nil, если при создании запроса возникли проблемы с конструирование URL.
 */
    func make(name: String?, endPoint: EndPoint, requestBahaviors: [WebRequestBehavior] = [LoggerBehavior()]) -> HTTPRequest? {
        guard let request = HTTPRequest(name: name,
            endPoint: endPoint,
            requestBahaviors: requestBahaviors,
            cacheBehavior: CacheBehavior(cache: URLCache.makePromiseCache())) else {
            return nil
        }

        request.delegate = self

        self.queue.async(flags: .barrier) {
            self.add(request: request)
        }

        return request
    }

    // make request with perform
    @discardableResult
    func makeAndPerform(name: String?,
        endPoint: EndPoint,
        requestBahaviors: [WebRequestBehavior] = [LoggerBehavior()],
        then completion: @escaping (Swift.Result<APIResponse<Data>, APIError>) -> Void) -> HTTPRequest? {

        let request = self.make(name: name, endPoint: endPoint, requestBahaviors: requestBahaviors)

        guard let req = request else {
            completion(.failure(.makeRequestError))
            return nil
        }

        req.delegate = self

        req.perform(on: .global(), completion: completion)

        return request
    }

    // make request with perform and decode
    @discardableResult
    func makeAndPerform<T: Decodable>(name: String?,
        endPoint: EndPoint,
        decoder: JSONDecoder,
        requestBahaviors: [WebRequestBehavior] = [LoggerBehavior()],
        then completion: @escaping (Swift.Result<APIResponse<T>, APIError>) -> Void) -> HTTPRequest? {

        let request = self.make(name: name, endPoint: endPoint, requestBahaviors: requestBahaviors)

        guard let req = request else {
            completion(.failure(.makeRequestError))
            return nil
        }

        req.delegate = self

        req.perform(decoder: decoder, completion: completion)

        return request
    }


    /**
     Завершает все запросы в пуле запросов.
     */

    func cancelAll() {
        for (_, request) in self.requests {
            request.cancel()
        }
    }

    // private
    private func add(request: HTTPRequest) {
        defer { self.clearCompletedRequests() }
        self.queue.async(flags: .barrier) {
            self.requests[request.id] = request
        }
    }

    private func remove(request: HTTPRequest) {
        defer { self.clearCompletedRequests() }
        self.queue.async(flags: .barrier) {
            self.requests[request.id] = nil
        }
    }

    private func remove(by name: String) {
        defer { self.clearCompletedRequests() }
        let id = name.hashValue
        self.queue.async(flags: .barrier) {
            self.requests[id] = nil
        }
    }

    private func clearCompletedRequests() {
        self.queue.async(flags: .barrier) {
            self.requests = self.requests.filter { $0.value.status != .done }
        }
    }
}

// MARK: - HTTPRequestDelegate
extension HTTPRequestPool: HTTPRequestDelegate {
    func statusChanged(_ request: HTTPRequest, with status: HTTPRequest.Status) {
        switch status {
        case .done:
            self.remove(request: request)
        default: break
        }
    }
}
