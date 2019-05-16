//
//  HTTPMethod.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 02/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

enum HTTPMethod: String, CustomStringConvertible {
    var description: String {
        return self.rawValue
    }

    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}
