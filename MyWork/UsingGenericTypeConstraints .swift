//
//  UsingGenericTypeConstraints .swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
extension Array where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
}

extension Collection where Element == String {
    func countWords() -> Int {
        return reduce(0) { count, string in
            let components = string.components(separatedBy: .whitespacesAndNewlines)
            return count + components.count
        }
    }
}

extension Sequence where Element == () -> Void {
    func callAll() {
        self.forEach {
            $0()
        }
    }
}
//observers.callAll()

fileprivate protocol ModelManager {
    associatedtype Model
    associatedtype Collection: Swift.Collection where Collection.Element == Model
    associatedtype Query
    //func models(matching query: String) -> [Model]
    func models(matching query: Query) -> Collection
}

fileprivate class USer { }
fileprivate class UManager: ModelManager {
    enum Query {
        case name(String)
        case ageRange(Range<Int>)
    }

    typealias Model = USer
    func models(matching query: UManager.Query) -> [USer] {
        return []
    }
}

fileprivate class MManager: ModelManager {
    typealias Model = (key: String, value: Int)

    enum Query {
        case name(String)
        case director(String)
    }

    func models(matching query: Query) -> [String: Int] {
        return [:]
    }
}
