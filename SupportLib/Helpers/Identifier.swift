//
//  Identifier.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 02/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public struct Identifier: Hashable {
    let string: String
}

extension Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        string = value
    }
}

extension Identifier: CustomStringConvertible {
    public var description: String {
        return string
    }
}

extension Identifier: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        string = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
