//
//  AsyncAwait.swift
//  MyWork
//
//  Created by Vladislav Gushin on 24/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate struct AsyncOperation<Value> {
    let queue: DispatchQueue = .main
    let closure: () -> Value

    func perform(then handler: @escaping (Value) -> Void) {
        queue.async {
            let value = self.closure()
            handler(value)
        }
    }
}
