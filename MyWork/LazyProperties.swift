//
//  LazyProperties.swift
//  MyWork
//
//  Created by Vladislav Gushin on 16/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

private class Cache<T> {
    var source = [String: T]()
    subscript(index: String) -> T? {
        get {
            return source[index]
        }
        set {
            self.source[index] = newValue
        }
    }
}

private class FileLoader {
    private lazy var cache = Cache<File>()

    func loadFile(named name: String) throws -> File {
        if let cache = cache[name] {
            return cache
        }
        let file = File()
        cache[name] = file
        return file
    }
}
