//
//  GCD.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 30/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - DispatchWorkItem
/*Одно распространенное заблуждение о GCD заключается в том, что «после того, как вы запланируете задачу, ее нельзя отменить, вам нужно использовать для этого API операций». Хотя раньше это было правдой, с iOS 8 и macOS 10.10 был представлен DispatchWorkItem, который предоставляет эту точную функциональность в очень простом в использовании API.
 
 Допустим, наш пользовательский интерфейс имеет панель поиска, и когда пользователь вводит символ, мы выполняем поиск, вызывая наш бэкэнд. Так как пользователь может печатать довольно быстро, мы не хотим запускать наш сетевой запрос сразу (это может привести к потере большого количества данных и емкости сервера), и вместо этого мы собираемся «отменить» эти события и выполнить только запрос как только пользователь не набрал в течение 0,25 секунд.
 
 Вот где приходит DispatchWorkItem. Инкапсулируя наш код запроса в рабочем элементе, мы можем очень легко отменить его всякий раз, когда он заменяется новым, например так:*/
fileprivate class ResultsLoader {
    func loadResults(forQuery: String) { }
}

/*Как мы видим выше, использование DispatchWorkItem на самом деле намного проще и приятнее в Swift, чем необходимость использования Timer или Operation, благодаря синтаксису замыкающего замыкания и тому, насколько хорошо GCD импортируется в Swift. Нам не нужны помеченные @objc методы или #selector - все это можно сделать с помощью замыканий.*/
fileprivate class SearchViewController: UIViewController, UISearchBarDelegate {
    private var pendingRequestWorkItem: DispatchWorkItem?
    private let resourceLoader = ResultsLoader()

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.pendingRequestWorkItem?.cancel()

        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.resourceLoader.loadResults(forQuery: searchText)
        }
        self.pendingRequestWorkItem = requestWorkItem

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }
}

// MARK: - Grouping and chaining tasks with DispatchGroup
/*
 Иногда нам нужно выполнить группу операций, прежде чем мы сможем двигаться дальше с нашей логикой. Например, скажем, нам нужно загрузить данные из группы источников данных, прежде чем мы сможем создать модель. Вместо того, чтобы отслеживать все источники данных самостоятельно, мы можем легко синхронизировать работу с DispatchGroup.
 
 Использование групп рассылки также дает нам большое преимущество в том, что наши задачи могут выполняться одновременно в отдельных очередях. Это позволяет нам начать с простого, а затем легко добавить параллелизм позже, если это необходимо, без необходимости переписывать какие-либо из наших задач. Все, что нам нужно сделать, это сделать сбалансированные вызовы для входа () и выхода () в группу диспетчеризации, чтобы она синхронизировала наши задачи.
 
 Давайте рассмотрим пример, в котором мы загружаем заметки из локального хранилища, iCloud Drive и серверной системы, а затем объединяем все результаты в коллекцию NoteCollection:
 */
fileprivate protocol DataSource {
    func load(then handler: ([Note]) -> Void)
}

extension DataSource {
    func load(then handler: ([Note]) -> Void) { }
}

fileprivate struct LocalDataSource: DataSource { }
fileprivate struct ICloudDataSource: DataSource { }
fileprivate struct BackendDataSource: DataSource { }
fileprivate struct Note { }

fileprivate class DataSourceWorker {
    private let localDataSource = LocalDataSource()
    private let iCloudDataSource = ICloudDataSource()
    private let backendDataSource = BackendDataSource()

    func load() {
        // First, we create a group to synchronize our tasks
        let group = DispatchGroup()

        // NoteCollection is a thread-safe collection class for storing notes
        var collection = [Note]()

        // The 'enter' method increments the group's task count…
        group.enter()
        self.localDataSource.load {
            collection += $0
            group.leave()
        }

        group.enter()
        self.iCloudDataSource.load {
            collection += $0
            group.leave()
        }

        group.enter()
        self.backendDataSource.load {
            collection += $0
            group.leave()
        }

        //// This closure will be called when the group's task count reaches 0
        group.notify(queue: .main) { [weak self] in
            self?.render(collection)
        }
    }

    private func render(_ collection: [Note]) {

    }
}

/*Приведенный выше код работает, но в нем много дублирования. Вместо этого давайте преобразуем его в расширение для Array, используя протокол DataSource в качестве ограничения того же типа для его типа Element:
*/
fileprivate extension Array where Element == DataSource {
    func load(onQueue: DispatchQueue = .main, then handler: @escaping ([Note]) -> Void) {
        onQueue.async {
            let group = DispatchGroup()
            var collection = [Note]()

            for dataSource in self {
                group.enter()
                dataSource.load {
                    collection += $0
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                handler(collection)
            }
        }
    }
}

extension DataSourceWorker {
    func loadNewVariant() {
        let sources: [DataSource] = [iCloudDataSource, localDataSource, backendDataSource]
        sources.load { [weak self] result in
            self?.render(result)
        }
    }
}

// MARK: - DispatchSemaphore
/*В то время как DispatchGroup предоставляет удобный и простой способ синхронизации группы асинхронных операций, оставаясь при этом асинхронным, DispatchSemaphore предоставляет способ синхронного ожидания группы асинхронных задач. Это очень полезно в инструментах командной строки или сценариях, где у нас нет цикла выполнения приложения, а вместо этого просто выполняем синхронно в глобальном контексте до завершения.
 
 Как и DispatchGroup, API семафоров очень прост в том, что мы увеличиваем или уменьшаем только внутренний счетчик, вызывая wait () или signal (). Вызов wait () перед сигналом () заблокирует текущую очередь до получения сигнала.
 
 Давайте создадим еще одну перегрузку в нашем расширении на массиве из ранее, которая синхронно возвращает коллекцию NoteCol иначе или выдает ошибку. Мы будем повторно использовать наш код на основе DispatchGroup, но просто координируем эту задачу с помощью семафора.*/
fileprivate enum NoteLoadingError: Error {
    case timedOut
}

extension Array where Element == DataSource {
    typealias NoteCollection = [Note]
    func load() throws -> NoteCollection {
        let semaphore = DispatchSemaphore(value: 0)
        var loadedCollection: NoteCollection?

        // We create a new queue to do our work on, since calling wait() on
        // the semaphore will cause it to block the current queue
        let loadingQueue = DispatchQueue.global()

        loadingQueue.async {
            // We extend 'load' to perform its work on a specific queue
            self.load(onQueue: loadingQueue) { collection in
                loadedCollection = collection

                // Once we're done, we signal the semaphore to unblock its queue
                semaphore.signal()
            }
        }

        // Wait with a timeout of 5 seconds
        _ = semaphore.wait(timeout: .now() + 5)

        guard let collection = loadedCollection else {
            throw NoteLoadingError.timedOut
        }

        return collection
    }
}


extension DataSourceWorker {
    func loadNewVariant2() {
        let sources: [DataSource] = [iCloudDataSource, localDataSource, backendDataSource]
        do {
            let collection = try sources.load()
            dump(collection)
        } catch {
            dump(error)
        }
    }
}

// MARK: - DispatchSource
/*Последняя «менее известная» особенность GCD, которую я хочу затронуть, заключается в том, как она обеспечивает способ наблюдения за изменениями в файле в файловой системе. Как и DispatchSemaphore, это то, что может быть очень полезно в скрипте или инструменте командной строки, если мы хотим автоматически реагировать на файл, редактируемый пользователем. Это позволяет нам легко создавать инструменты разработчика, которые имеют функции «живого редактирования».
 
 Отправка источников возможна в нескольких разных вариантах, в зависимости от того, что мы хотим наблюдать. В этом случае мы будем использовать DispatchSourceFileSystemObject, который позволяет нам наблюдать за событиями из файловой системы.
 
 Давайте рассмотрим пример реализации простого FileObserver, который позволяет нам прикрепить закрытие, которое будет запускаться при каждом изменении данного файла. Он работает путем создания источника отправки с использованием fileDescriptor и DispatchQueue для выполнения наблюдения и использует файлы для ссылки на файл для наблюдения:*/
fileprivate struct File {
    let path: String
}

fileprivate class FileObserver {
    private let file: File
    private let queue: DispatchQueue
    private var source: DispatchSourceFileSystemObject?

    init(file: File) {
        self.file = file
        self.queue = DispatchQueue(label: "com.myapp.fileObserving")
    }

    func start(closure: @escaping () -> Void) {
        // We can only convert an NSString into a file system representation
        let path = (file.path as NSString)
        let fileSystemRepresentation = path.fileSystemRepresentation

        // Obtain a descriptor from the file system
        let fileDescriptor = open(fileSystemRepresentation, O_EVTONLY)

        // Create our dispatch source
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: .write,
            queue: queue
        )

        // Assign the closure to it, and resume it to start observing
        source.setEventHandler(handler: closure)
        source.resume()
        self.source = source
    }
}

fileprivate func using(file: File) {
    let observer = try? FileObserver(file: file)

    observer?.start {
        print("File was changed")
    }
}
