//
//  Delegation.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
class File {
    let path: String
    init() {
        self.path = ""
    }
    func read()throws -> Data {
        return Data(base64Encoded: "123")!
    }
}

//PROTOCOLS
protocol FileImporterDelegate: AnyObject {
    func fileImporter(_ importer: FileImporterProtocols,
                      shouldImportFile file: File) -> Bool

    func fileImporter(_ importer: FileImporterProtocols,
                      didAbortWithError error: Error)

    func fileImporterDidFinish(_ importer: FileImporterProtocols)
}

class FileImporterProtocols {
    weak var delegate: FileImporterDelegate?
    private func processFileIfNeeded(_ file: File) {
        guard let delegate = delegate else {
            // Uhm.... what to do here?
            return
        }
        let shouldImport = delegate.fileImporter(self, shouldImportFile: file)
        guard shouldImport else { return }
        process(file)
    }
    func process(_ file: File) { }
}


//Closures

class FileImporterClosure {
    private let predicate: (File) -> Bool

    init(predicate: @escaping (File) -> Bool) {
        self.predicate = predicate
    }

    private func processFileIfNeeded(_ file: File) {
        let shouldImport = predicate(file)
        guard shouldImport else {
            return
        }
        process(file)
    }

    func process(_ file: File) { }
}

//Configuration

struct FileImporterConfiguration {
    var predicate: (File) -> Bool
    var errorHandler: (Error) -> Void
    var completionHandler: () -> Void
}

class FileImporterWithConfiguration {
    private let configuration: FileImporterConfiguration
    init(configuration: FileImporterConfiguration) {
        self.configuration = configuration
    }

    private func processFileIfNeeded(_ file: File) {
        let shouldImport = configuration.predicate(file)

        guard shouldImport else {
            return
        }

        process(file)
    }
    func process(_ file: File) { }
    private func handle(_ error: Error) {
        configuration.errorHandler(error)
    }

    private func importDidFinish() {
        configuration.completionHandler()
    }
}

//Вспомогательные методы для работы "по умолчанию"
extension FileImporterConfiguration {
    init(predicate: @escaping (File) -> Bool) {
        self.predicate = predicate
        self.errorHandler = { _ in }
        self.completionHandler = { }
    }

    static var importAll: FileImporterConfiguration {
        return .init(predicate: { _ in true })
    }
}

fileprivate let importer = FileImporterWithConfiguration(configuration: .importAll)
