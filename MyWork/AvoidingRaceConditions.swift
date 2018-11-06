//
//  AvoidingRaceConditions.swift
//  MyWork
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

typealias AccessToken = String

extension AccessToken {
    var isValid: Bool {
        return !self.isEmpty
    }
}

struct AccessTokenLoader {
    func load(then handler: (Result<String>) -> Void) {
        handler(.result("123"))
    }
}

class AccessTokenService {
    typealias Handler = (Result<AccessToken>) -> Void

    private let queue: DispatchQueue
    private let loader: AccessTokenLoader
    private var token: AccessToken?

    private var pendingHandlers = [Handler]()

    init(loader: AccessTokenLoader, queue: DispatchQueue = .init(label: "AccessToken")) {
        self.loader = loader
        self.queue = queue
    }

    func retrieveToken(then handler: @escaping Handler) {
        queue.async { [weak self] in
            self?.performRetrieval(with: handler)
        }
    }

    func performRetrieval(with handler: @escaping Handler) {
        if let token = token, token.isValid {
            return handler(.result(token))
        }
        pendingHandlers.append(handler)
        guard pendingHandlers.count == 1 else { return }

        loader.load { [weak self] result in
            self?.queue.async {
                self?.handle(result)
            }
        }
    }

    func handle(_ result: Result<AccessToken>) {
        token = result.value
        let handlers = pendingHandlers
        pendingHandlers = []
        handlers.forEach { $0(result) }
    }
}
