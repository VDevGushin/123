//
//  FactoryPattern.swift
//  MyWork
//
//  Created by Vladislav Gushin on 12/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
//MARK: - problem place

fileprivate final class Request {
    enum State {
        case pending
        case ongoing
        case complete(Result<String>)
    }

    let url: URL
    let parameters: [String: String]
    fileprivate(set) var state: State = State.pending

    init(url: URL, parameters: [String: String] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}

fileprivate final class RequestDataLoader {
    typealias Completion = () -> Void

    func perform(_ request: Request, completion: Completion) {
        completion()
    }
}

enum RequestURL {
    typealias RawValue = URL
    case todoList
    var rawValue: RawValue {
        switch self {
        case .todoList:
            return URL(string: "test")!
        }
    }

}
//Using
final class TodoListVC: UIViewController {
    private let request = Request(url: RequestURL.todoList.rawValue)
    private let dataLoader = RequestDataLoader()

    func loadItems() {
        self.dataLoader.perform(request) {
            //result
        }
    }
}

//MARK: - Factory methods (for multi request)

fileprivate class RequestV2 {
    let url: URL
    let parameters: [String: String]

    init(url: URL, parameters: [String: String] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}

fileprivate final class StatefulRequst: RequestV2 {
    enum State {
        case pending
        case ongoing
        case completed(Result<String>)
    }
    var state = State.pending
}

fileprivate extension RequestV2 {
    func makeStateful() -> StatefulRequst {
        return StatefulRequst(url: self.url, parameters: self.parameters)
    }
}

fileprivate final class RequestDataLoaderV2 {
    typealias Completion = () -> Void

    func perform(_ request: RequestV2) {
        perform(request.makeStateful())
    }

    private func perform(_ request: StatefulRequst) {

    }
}
