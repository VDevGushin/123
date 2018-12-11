//
//  TypeSafeIdentifiers .swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
//Простая модель
fileprivate struct UserOLD {
    let id: UUID
    let name: String
}

//UUID может не всегда подходить (например при работе с другими системами)
fileprivate struct Identifier<Value>: Hashable, ExpressibleByStringLiteral, CustomStringConvertible, Codable {
    let string: String

    init(stringLiteral value: String) {
        string = value
    }

    var description: String {
        return string
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.string = try container.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.string)
    }
}

fileprivate struct User {
    let id: Identifier<User>
    let name: String
}


fileprivate func test() {
    let id: Identifier<User> = "new user"
    print(id)

    let user = User(id: "new-user", name: "John")
    print(user.id)
}

/*
Не все идентификаторы поддерживаются строками,
 и в некоторых ситуациях нам может потребоваться,
 чтобы наш тип идентификатора также поддерживал другие вспомогательные значения,
 такие как Int или даже UUID.
*/
fileprivate protocol Identifiable {
    associatedtype RawIdentifier: Codable = String
    var id: Identifier<Self> { get }
}

fileprivate struct Identifier1<Value: Identifiable> {
    let rawValue: Value.RawIdentifier
    
    init(rawValue: Value.RawIdentifier) {
        self.rawValue = rawValue
    }
}

fileprivate struct User1: Identifiable {
    let id: Identifier<User1>
    let name: String
}
