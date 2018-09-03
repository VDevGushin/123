//
//  TypeSafeIdentifiers.swift
//  MyWork
//
//  Created by Vladislav Gushin on 28/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct Identifier: Hashable {
    let string: String
}

extension Identifier: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        string = value
    }
}
//to make it simple to print an identifier
extension Identifier: CustomStringConvertible {
    var description: String {
        return string
    }
}

extension Identifier: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        string = try container.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}

//Even more type safety

struct TypeSafeUser {
    let id: Identifier
    let name: String
}

//MARK: Using
struct TypeIdentifiersTest {
    func test() {
        let id = Identifier(string: "new-user")
        let d : Identifier = "2"
        let id2: Identifier = "new-user" // ExpressibleByStringLiteral
        let user = TypeSafeUser(id: "new-user", name: "John")
    }
}

//MARK: - Generalizing our generic
protocol Identifiable {
    associatedtype RawIdentifier: Codable
    var id: Identifier2<Self> { get }
}

struct Identifier2<Value : Identifiable> {
    let rawValue: Value.RawIdentifier
    init(rawValue: Value.RawIdentifier) {
        self.rawValue = rawValue
    }
}

struct GroupTEST: Identifiable {
    typealias RawIdentifier = Int
    let id: Identifier2<GroupTEST>
    let name: String
}
