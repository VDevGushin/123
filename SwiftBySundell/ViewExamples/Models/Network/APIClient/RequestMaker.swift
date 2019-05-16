//
//  RequestMaker.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 15/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

final class HTTPRequest {
    typealias APIClientCompletion = (Swift.Result<APIResponse<Data>, APIError>) -> Void

    enum Status {
        case normal, request
    }

    var status: Status = .normal
    var id: Int = 0

    private let requestBahavior: WebRequestBehavior
    private let endPoint: EndPoint
    private let urlRequest: URLRequest

    private var currentRequest: (Promise<(data: Data, response: URLResponse)>, cancel: () -> Void)?

    init(name: String?, endPoint: EndPoint, requestBahaviors: [WebRequestBehavior]) throws {
        self.requestBahavior = CombinedWebRequestBehavior(behaviors: requestBahaviors)
        self.endPoint = endPoint
        self.urlRequest = try self.endPoint.makeURLRequest()
        self.id = name != nil ? name!.hashValue : ObjectIdentifier(self).hashValue
    }

    func cancel() {
        self.currentRequest?.cancel()
        self.currentRequest = nil
    }

    func perform(on queue: DispatchQueue = .global(), completion: @escaping APIClientCompletion) {
        queue.async {
            self.status = .request
            self.currentRequest = self.makeRequest()
            self.currentRequest?.0.done(on: .main) { [weak self] result in
                guard let self = self else { return }
                self.status = .normal
                
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    completion(.failure(.requestFailed(nil))); return
                }
                
                completion(Swift.Result.success(APIResponse(statusCode: httpResponse.statusCode, body: result.data)))
            }.catch(on: .main, policy: .allErrors) { [weak self] error in
                guard let self = self else { return }
                self.status = .normal

                if (error as? PromiseKit.PMKError)?.isCancelled ?? false {
                    return completion(.failure(.canceled))
                }
                completion(.failure(.requestFailed(error)))
            }.finally { [weak self] in
                self?.currentRequest = nil
            }
        }
    }
}

private extension HTTPRequest {
    func makeRequest() -> (Promise<(data: Data, response: URLResponse)>, cancel: () -> Void) {
        var cancelMe = false
        self.requestBahavior.beforeSend(with: self.urlRequest)
        let fetch = URLSession.shared.dataTask(.promise, with: self.urlRequest)
        let promise = Promise<(data: Data, response: URLResponse)> { resolver in
            after(seconds: 10).done {
                fetch.done { [weak self] result in
                    guard let self = self else { return }
                    guard !cancelMe else {
                        self.requestBahavior.afterFailure(error: PMKError.cancelled, response: nil)
                        return resolver.reject(PMKError.cancelled)
                    }
                    self.requestBahavior.afterSuccess(result: result.data, response: result.response)
                    resolver.fulfill(result)
                }.catch { [weak self] error in
                    guard let self = self else { return }
                    self.requestBahavior.afterFailure(error: error, response: nil)
                    resolver.reject(error)
                }
            }
        }
        let cancel = {
            cancelMe = true
        }
        return (promise, cancel)
    }
}
