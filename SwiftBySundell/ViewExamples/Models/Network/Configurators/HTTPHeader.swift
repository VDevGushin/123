//
//  HTTPHeader.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 02/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct HTTPHeader {
    let field: String
    let value: String
}

extension Array where Element == HTTPHeader {
    func convertToDictionary() -> [String: String] {
        var result: [String: String] = [:]
        for element in self {
            result[element.field] = element.value
        }
        return result
    }
}
