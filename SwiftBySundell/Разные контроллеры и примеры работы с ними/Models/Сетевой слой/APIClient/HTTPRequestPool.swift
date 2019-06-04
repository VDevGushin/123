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

    var count: Int {
        return self.requests.count
    }

    private init() { }

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

    func cancelAll(){
        for (_,request) in self.requests{
            request.cancel()
        }
    }
    
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
            let filtered = self.requests.filter {
                $0.value.status != .done
            }
            self.requests = filtered
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
