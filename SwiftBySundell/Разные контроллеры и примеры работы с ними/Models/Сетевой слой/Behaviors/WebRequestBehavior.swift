//
//  WebRequestBehavior.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

protocol WebRequestBehavior {
    var additionalHeaders: [String: String] { get }
    func beforeSend(with: URLRequest)
    func afterSuccess(result: Any, response: URLResponse?)
    func afterFailure(error: Error, response: URLResponse?)
}

extension WebRequestBehavior {
    var additionalHeaders: [String: String] {
        return [:]
    }

    func beforeSend(with: URLRequest) { }
    func afterSuccess(result: Any, response: URLResponse?) { }
    func afterFailure(error: Error, response: URLResponse?) { }
}
