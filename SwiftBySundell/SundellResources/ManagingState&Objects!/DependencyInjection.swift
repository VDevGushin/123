//
//  DependencyInjection.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 20/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - help classes
fileprivate protocol PhotoLibrary { }

fileprivate class PHPhotoLibrary: PhotoLibrary {
    private init() { }
    static let shared = PHPhotoLibrary()
}

fileprivate struct PhotoEditorEngine { }

fileprivate class FileManager {
    private init() { }
    static let shared = FileManager()
}
fileprivate struct Cache { }

fileprivate struct Note {
    let value: String
}
// MARK: - Initializer-based
fileprivate class FileLoader {
    private let filemanager: FileManager
    private let cache: Cache

    init(fileManager: FileManager = .shared, cache: Cache = .init()) {
        self.filemanager = fileManager
        self.cache = cache
    }
}

// MARK: - Property-based
//В тестах мы можем просто переназначать свойства нашего контроллера
fileprivate class PhotoEditorViewController: UIViewController {
    var library: PhotoLibrary = PHPhotoLibrary.shared
    var engine = PhotoEditorEngine()
}

// MARK: - Parameter-based

fileprivate class NoteManager {
    func loadNotes(matching query: String,
                   on queue: DispatchQueue = .global(qos: .userInitiated),
                   then handler: @escaping ([Note]) -> Void) {
        queue.async { [weak self] in
            let dataBase = self?.loadDataBase()
            let notes = dataBase?.map{ value in
                return Note(value: value)
            }
            handler(notes ?? [])
        }
    }

    private func loadDataBase() -> [String] { return [""] }
}
