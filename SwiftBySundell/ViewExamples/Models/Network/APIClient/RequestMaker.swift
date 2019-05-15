//
//  RequestMaker.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 15/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

final class RequestMaker {
    private let requestBahavior: WebRequestBehavior
    private let endPoint: EndPoint
    private let urlRequest: URLRequest

    init(endPoint: EndPoint, requestBahaviors: [WebRequestBehavior]) throws {
        self.requestBahavior = CombinedWebRequestBehavior(behaviors: requestBahaviors)
        self.endPoint = endPoint
        self.urlRequest = try self.endPoint.makeURLRequest()
    }

    func makeRequest() -> Promise<APIResponse<Data>> {
        self.requestBahavior.beforeSend(with: self.urlRequest)
        let fetch = URLSession.shared.dataTask(.promise, with: self.urlRequest).map {
            APIResponse(statusCode: ($0.response as? HTTPURLResponse)?.statusCode ?? 500, body: $0.data)
        }
        return fetch

    }

    func makeRequestWithCancel() -> (Promise<APIResponse<Data>>, cancel: () -> Void) {
        let fetch = self.makeRequest()
        var cancelMe = false

        let promise = Promise<APIResponse<Data>> { resolver in
            fetch.done { result in
                guard !cancelMe else {
                    self.requestBahavior.afterFailure(error: PMKError.cancelled, response: nil)
                    return resolver.reject(PMKError.cancelled)
                }
                self.requestBahavior.afterSuccess(result: result, response: nil)
                resolver.fulfill(result)
            }.catch { error in
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
