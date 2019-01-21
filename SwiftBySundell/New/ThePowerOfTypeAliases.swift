//
//  ThePowerOfTypeAliases.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 21/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
//MARK: - Simple
typealias Kilograms = Double
fileprivate struct Packege {
    var weight: Kilograms
}

// MARK: - Specializing generics
fileprivate protocol FileStorageLocation { }
fileprivate class LocalFileStorageLocation: FileStorageLocation { }
fileprivate class CloudStorageLocation: FileStorageLocation { }

fileprivate class FileStorage<Key: Hashable, Location: FileStorageLocation> {
}

//NO typealias
fileprivate class NoteSyncController {
    init(localStorage: FileStorage<String, LocalFileStorageLocation>,
         cloudStorage: FileStorage<String, CloudStorageLocation>) {
    }

    init(localStorageAliase: Note.LocalStorage,
         cloudStorageAliase: Note.CloudStorage) {
    }
}

//With typealias
fileprivate struct Note {
    typealias LocalStorage = FileStorage<String, LocalFileStorageLocation>
    typealias CloudStorage = FileStorage<String, CloudStorageLocation>
}

// MARK: - Type-driven logic

fileprivate protocol Indexed {
    associatedtype RawIndex
    var index: Index<Self> { get }
}

fileprivate struct Index<Object: Indexed> {
    typealias RawValue = Object.RawIndex
    let rawValue: RawValue
}

// MARK: - Generic closure aliases
typealias Handler<T> = (T) -> Void
