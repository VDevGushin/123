//
//  CombinedWebRequestBehavior.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct CombinedWebRequestBehavior: WebRequestBehavior {

    let behaviors: [WebRequestBehavior]

    var additionalHeaders: [String: String] {
        return behaviors.reduce([String: String](), { sum, behavior in
            var sum = sum
            sum.merge(with: behavior.additionalHeaders)
            return sum
        })
    }

    func beforeSend(with: URLRequest) {
        behaviors.forEach({ $0.beforeSend(with: with) })
    }

    func afterSuccess(result: Any, response: URLResponse?) {
        behaviors.forEach({ $0.afterSuccess(result: result, response: response) })
    }


    func afterFailure(error: Error, response: URLResponse?) {
        behaviors.forEach({ $0.afterFailure(error: error, response: response) })
    }
}

fileprivate extension Dictionary {
    mutating func merge(with: [Key: Value]) {
        for (k, v) in with {
            updateValue(v, forKey: k)
        }
    }
}
