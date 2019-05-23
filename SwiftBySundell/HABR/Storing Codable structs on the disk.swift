//
//  Storing Codable structs on the disk.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 23/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Большинство наших приложений являются REST-клиентами для некоторых бэкэндов. При разработке такого рода приложений мы хотим, чтобы он работал автономно. В этом случае мы должны кэшировать данные где-то локально на устройстве, чтобы сделать его читаемым без подключения к интернету.
 
 Apple предоставляет инфраструктуру CoreData, которая является лучшим способом локального хранения данных вашего приложения. Он имеет много отличных функций, которые помогут вам ускорить разработку. Однако его сложно использовать в качестве простого кэша. В большинстве случаев нам просто нужно отображать кэшированные данные без каких-либо дополнительных манипуляций. На мой взгляд, все, что нам нужно, это чистое дисковое хранилище. На этой неделе мы обсудим, как легко мы можем реализовать прямое хранилище дисков для наших Codable структур.
 
 Давайте начнем с определения нескольких протоколов для нашей логики хранения. Я хочу разделить доступ к доступным для записи и читаемым частям хранилища, и именно здесь мы можем использовать функцию составления протокола языка Swift.*/

/*Здесь у нас есть два протокола, описывающие операции чтения и записи в хранилище. Протоколы также предоставляют асинхронную версию для чтения и записи действий с обработчиками завершения. Мы также создаем хранилище typealias, которое состоит из двух протоколов. Теперь мы можем начать работать с классом DiskStorage, который реализует наши протоколы хранения.*/

typealias StorageHandler<T> = (Result<T, Error>) -> Void

protocol ReadableStorage {
    func fetchValue(for key: String) throws -> Data
    func fetchValue(for key: String, handler: @escaping StorageHandler<Data>)
}

protocol WritableStorage {
    func save(value: Data, for key: String) throws
    func save(value: Data, for key: String, handler: @escaping StorageHandler<Data>)
}

typealias Storage = ReadableStorage & WritableStorage

enum StorageError: Error {
    case notFound
    case cantWrite(Error)
}

class DiskStorage {
    private let queue: DispatchQueue
    private let fileManager: FileManager
    private let path: URL

    init(path: URL, queue: DispatchQueue = .init(label: "DiskCache.Queue"), fileManager: FileManager = FileManager.default) {
        self.path = path
        self.queue = queue
        self.fileManager = fileManager
    }

    private func createFolders(in url: URL) throws {
        let folderUrl = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folderUrl.path) {
            try fileManager.createDirectory(
                at: folderUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
}

// MARK: - Save
extension DiskStorage: WritableStorage {
    func save(value: Data, for key: String) throws {
        let url = self.path.appendingPathComponent(key)
        do {
            try self.createFolders(in: url)
            try value.write(to: url, options: .atomic)
        } catch {
            throw StorageError.cantWrite(error)
        }
    }

    func save(value: Data, for key: String, handler: @escaping StorageHandler<Data>) {
        self.queue.async {
            do {
                try self.save(value: value, for: key)
                handler(.success(value))
            } catch {
                handler(.failure(error))
            }
        }
    }
}

// MARK: - Read
extension DiskStorage: ReadableStorage {
    func fetchValue(for key: String) throws -> Data {
        let url = self.path.appendingPathComponent(key)
        guard let data = self.fileManager.contents(atPath: url.path) else {
            throw StorageError.notFound
        }
        return data
    }

    func fetchValue(for key: String, handler: @escaping StorageHandler<Data>) {
        self.queue.async {
            handler(Result { try self.fetchValue(for: key) })
        }
    }
}

/*Класс CodableStorage оборачивает наш класс DiskStorage, чтобы добавить логику кодирования-декодирования JSON. Он использует общие ограничения, чтобы понять, как декодировать и кодировать данные. Пришло время использовать наш CodableStorage в реальной жизни.*/
class CodableStorage {
    private let storage: DiskStorage
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(storage: DiskStorage, decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.fetchValue(for: key)
        return try decoder.decode(T.self, from: data)
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }
}

/*В приведенном выше примере кода вы можете увидеть использование класса CodableStorage. Мы создаем экземпляр класса DiskCache, который использует временную папку для хранения данных. Временная шкала - это простая кодируемая структура, представляющая массив строк, которые мы храним в нашем CodableStorage.*/
struct Timeline: Codable {
    let tweets: [String]
}

fileprivate func test() {
    let path = URL(fileURLWithPath: NSTemporaryDirectory())
    let disk = DiskStorage(path: path)
    let storage = CodableStorage(storage: disk)

    let timeline = Timeline(tweets: ["Hello", "World", "!!!"])
    try? storage.save(timeline, for: "timeline")
    do {
        let cached: Timeline = try storage.fetch(for: "timeline")
        print(cached)
    } catch { }
}

