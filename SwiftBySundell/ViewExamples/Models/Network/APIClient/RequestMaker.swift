//
//  RequestMaker.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 15/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

final class HTTPRequestPool: HTTPRequestDelegate {
    private let queue = DispatchQueue(label: "HTTPRequestPool", attributes: .concurrent)
    static let shared = HTTPRequestPool()
    var requests: [Int: HTTPRequest]

    private init() {
        self.requests = [:]
    }

    var count: Int {
        return self.requests.count
    }

    func make(name: String?, endPoint: EndPoint, requestBahaviors: [WebRequestBehavior]) -> HTTPRequest? {
        guard let request = HTTPRequest(name: name, endPoint: endPoint, requestBahaviors: requestBahaviors) else {
            return nil
        }
        request.delegate = self
        self.queue.async(flags: .barrier) {
            self.add(request: request)
        }
        return request
    }

    func statusChanged(_ request: HTTPRequest, with status: HTTPRequest.Status) {
        switch status {
        case .done:
            self.remove(request: request)
        default: break
        }
    }

    private func add(request: HTTPRequest) {
        defer { self.clearCompletedRequests() }
        print(self.count)
        self.requests[request.id] = request
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
            let filtered = self.requests.filter {
                $0.value.status != .done
            }
            self.requests = filtered
        }
    }
}

protocol HTTPRequestDelegate: class {
    func statusChanged(_ request: HTTPRequest, with status: HTTPRequest.Status)
}
final class HTTPRequest {
    typealias HTTPRequestResult = (Promise<(data: Data, response: URLResponse)>, cancel: () -> Void)
    typealias APIClientCompletion = (Swift.Result<APIResponse<Data>, APIError>) -> Void
    enum Status {
        case normal, request, done
    }

    weak var delegate: HTTPRequestDelegate?
    var id: Int = 0

    var status: Status = .normal {
        didSet {
            self.delegate?.statusChanged(self, with: self.status)
        }
    }

    private let requestBahavior: WebRequestBehavior
    private let endPoint: EndPoint
    private let urlRequest: URLRequest
    private var currentRequest: (Promise<(data: Data, response: URLResponse)>, cancel: () -> Void)?

    init?(name: String?, endPoint: EndPoint, requestBahaviors: [WebRequestBehavior]) {
        self.requestBahavior = CombinedWebRequestBehavior(behaviors: requestBahaviors)
        self.endPoint = endPoint
        guard let request = try? self.endPoint.makeURLRequest() else {
            return nil
        }
        self.urlRequest = request
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
            self.currentRequest?.0.done(on: .main) { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    return completion(.failure(.requestFailed(nil)));
                }
                completion(Swift.Result.success(APIResponse(statusCode: httpResponse.statusCode, body: result.data)))
            }.catch(on: .main, policy: .allErrors) { error in
                if (error as? PromiseKit.PMKError)?.isCancelled ?? false {
                    return completion(.failure(.canceled))
                }
                completion(.failure(.requestFailed(error)))
            }.finally { [weak self] in
                self?.status = .done
                self?.currentRequest = nil
            }
        }
    }
}

private extension HTTPRequest {
    func makeRequest() -> HTTPRequestResult {
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
