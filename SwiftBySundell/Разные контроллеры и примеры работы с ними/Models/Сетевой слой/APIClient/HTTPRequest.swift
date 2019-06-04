//
//  HTTPRequest.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 31/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - Delegate
protocol HTTPRequestDelegate: class {
    func statusChanged(_ request: HTTPRequest, with status: HTTPRequest.Status)
}

// MARK: - HTTPRequest
final class HTTPRequest {
    deinit {
        print("deinit")
    }

    weak var delegate: HTTPRequestDelegate?
    var id: Int = 0

    private let cacheBehavior: CacheBehavior

    var status: Status = .normal {
        didSet { self.delegate?.statusChanged(self, with: self.status) }
    }

    private let requestBahavior: WebRequestBehavior
    private let endPoint: EndPoint
    private let urlRequest: URLRequest
    private var currentRequest: (Promise<(Response)>, cancel: () -> Void)?

    init?(name: String?, endPoint: EndPoint, requestBahaviors: [WebRequestBehavior]) {
        self.requestBahavior = CombinedWebRequestBehavior(behaviors: requestBahaviors)
        self.endPoint = endPoint
        guard let request = try? self.endPoint.makeURLRequest() else {
            return nil
        }
        self.urlRequest = request
        self.cacheBehavior = CacheBehavior(cache: URLCache.makePromiseCache())
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

// MARK: - Make request
extension HTTPRequest {
    fileprivate func makeRequest() -> HTTPRequestResult {
        var cancelMe = false
        self.requestBahavior.beforeSend(with: self.urlRequest)

        let fetch = URLSession.makeDefaultSession(cache: self.cacheBehavior.cache).dataTask(.promise, with: self.urlRequest)

        let promise = Promise<Response> { resolver in
            fetch.done { [weak self] result in
                guard let self = self else { return }
                guard !cancelMe else {
                    self.requestBahavior.afterFailure(error: PMKError.cancelled, response: nil)
                    return resolver.reject(PMKError.cancelled)
                }

                let requestResponse = self.cacheBehavior.modify(request: self.urlRequest, acceptedResponse: .init(data: result.data, response: result.response, date: Date()))

                self.requestBahavior.afterSuccess(result: result.data, response: result.response)

                resolver.fulfill(requestResponse)
            }.catch { [weak self] error in
                guard let self = self else { return }
                self.requestBahavior.afterFailure(error: error, response: nil)
                resolver.reject(error)
            }
        }
        let cancel = {
            cancelMe = true
        }
        return (promise, cancel)
    }
}

// MARK: - Class helpers
extension HTTPRequest {
    typealias HTTPRequestResult = (Promise<Response>, cancel: () -> Void)
    typealias APIClientCompletion = (Swift.Result<APIResponse<Data>, APIError>) -> Void

    enum Status {
        case normal, request, done
    }

    struct Response {
        let data: Data
        let response: URLResponse
        let date: Date?
    }
}
