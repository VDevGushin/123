//
//  DeepGCD.swift
//  MyWork
//
//  Created by Vladislav Gushin on 20/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//Delaying a cancellable task with DispatchWorkItem====================================================================================================>
fileprivate class RequestLoader {
    func loadResults(forQ: String) { }
}

fileprivate class GCDSearchViewController: UIViewController, UISearchBarDelegate {
    private var pendingRequestWorkItem: DispatchWorkItem?
    private let loader: RequestLoader = RequestLoader()

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.loader.loadResults(forQ: searchText)
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }
}

//Grouping and chaining tasks with DispatchGroup====================================================================================================>
fileprivate class LocalDataSource { }

//thread-safe collection
fileprivate class Note { }
fileprivate class NoteCollection: SynchronizedArray<Note> { }
fileprivate protocol ILoader { }
extension ILoader {
    func load(completion: (Note) -> Void) {
        completion(Note())
    }
}

fileprivate class DataSourceLoader: ILoader { }
fileprivate class ICloudDataSource: ILoader { }
fileprivate class BackendDataSource: ILoader { }

fileprivate class GroupingChaining {
    let sourceLoader = DataSourceLoader()
    let iCloudDataSource = ICloudDataSource()
    let backendDataSource = BackendDataSource()

    func render<T>(_ collection: SynchronizedArray<T>) { }

    func test() {
        let collection = NoteCollection()
        let group = DispatchGroup()

        group.enter()
        sourceLoader.load {
            collection.append($0)
            group.leave()
        }

        group.enter()
        iCloudDataSource.load {
            collection.append($0)
            group.leave()
        }

        group.enter()
        backendDataSource.load {
            collection.append($0)
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.render(collection)
        }

        //Используем нижее расширение чтобы убрать дублирование кода
        let dataSources: [ILoader] = [sourceLoader, iCloudDataSource, backendDataSource]
        dataSources.load {
            self.render($0)
        }

    }
}

extension Array where Element == ILoader {
    func load(complition: @escaping (NoteCollection) -> Void) {
        let collection = NoteCollection()
        let group = DispatchGroup()
        self.forEach {
            group.enter()
            $0.load {
                collection.append($0)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            complition(collection)
        }
    }
}

//Waiting for asynchronous tasks with DispatchSemaphore====================================================================================================>
//Будем использовать семафор , чтобы все асинхронные задачи стали синхронными
extension GroupingChaining {
    func test2() -> Void {
        let dataSources: [ILoader] = [sourceLoader, iCloudDataSource, backendDataSource]
        do {
            let collection = try dataSources.load()
            print(collection)
        } catch {

        }
    }
}

enum NoteLoadingError: Error {
    case timedOut
}

extension Array where Element == ILoader {
    func load() throws -> NoteCollection {
        let semaphore = DispatchSemaphore(value: 0)
        var loadedCollection: NoteCollection?

        // We create a new queue to do our work on, since calling wait() on
        // the semaphore will cause it to block the current queue
        let loadingQueue = DispatchQueue.global()

        loadingQueue.async {
            // We extend 'load' to perform its work on a specific queue
            self.load { collection in
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

//Observing changes in a file with DispatchSource====================================================================================================>
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
        let source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor,
                                                               eventMask: .write,
                                                               queue: queue)

        // Assign the closure to it, and resume it to start observing
        source.setEventHandler(handler: closure)
        source.resume()
        self.source = source
    }
}

fileprivate class TestFileObserver {
    func test() {
        let observer = FileObserver(file: File())
        observer.start {
            print("File was changed")
        }
    }
}
