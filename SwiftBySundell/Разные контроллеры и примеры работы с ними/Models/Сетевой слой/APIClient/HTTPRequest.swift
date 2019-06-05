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
    weak var delegate: HTTPRequestDelegate?
    var id: Int = 0

    private var cacheBehavior: CacheBehavior?

    var status: Status = .normal {
        didSet { self.delegate?.statusChanged(self, with: self.status) }
    }

    private let requestBahavior: WebRequestBehavior
    private let endPoint: EndPoint
    private let urlRequest: URLRequest
    private var currentRequest: (Promise<(data: Data, response: URLResponse)>, cancel: () -> Void)?

    init?(name: String?, endPoint: EndPoint, requestBahaviors: [WebRequestBehavior], cacheBehavior: CacheBehavior?) {
        self.requestBahavior = CombinedWebRequestBehavior(behaviors: requestBahaviors)
        self.endPoint = endPoint
        guard let request = try? self.endPoint.makeURLRequest() else {
            return nil
        }
        self.cacheBehavior = cacheBehavior
        self.urlRequest = request
        self.id = name != nil ? name!.hashValue : ObjectIdentifier(self).hashValue
    }

    deinit {
        print("deinit")
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

    func perform<T: Decodable>(on queue: DispatchQueue = .global(),
        decoder: JSONDecoder,
        completion: @escaping (Swift.Result<APIResponse<T>, APIError>) -> Void) {

        self.perform(on: queue) { result in
            completion(result.decode(with: decoder))
        }
    }
}

// MARK: - Make request
extension HTTPRequest {
    fileprivate func makeRequest() -> HTTPRequestResult {
        var cancelMe = false

        self.requestBahavior.beforeSend(with: self.urlRequest)

        let fetch = URLSession.makeSession(with: self.cacheBehavior).dataTask(.promise, with: self.urlRequest)

        let promise = Promise<(data: Data, response: URLResponse)> { resolver in
            fetch.done { [weak self] result in
                guard let self = self else { return }
                var result = result
                guard !cancelMe else {
                    self.requestBahavior.afterFailure(error: PMKError.cancelled, response: nil)
                    return resolver.reject(PMKError.cancelled)
                }

                result = self.cacheBehavior?.modify(request: self.urlRequest, acceptedResponse: result) ?? result

                self.requestBahavior.afterSuccess(result: result.data, response: result.response)

                resolver.fulfill(result)
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
    typealias HTTPRequestResult = (Promise<(data: Data, response: URLResponse)>, cancel: () -> Void)
    typealias APIClientCompletion = (Swift.Result<APIResponse<Data>, APIError>) -> Void

    enum Status {
        case normal, request, done
    }
}
