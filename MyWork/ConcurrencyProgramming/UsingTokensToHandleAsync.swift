//
//  UsingTokensToHandleAsync.swift
//  MyWork
//
//  Created by Vladislav Gushin on 18/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import Unbox
/*
 Основная идея API на основе токенов заключается в том, что функция, запускающая асинхронную   операцию, возвращает токен. Потом этот токен можно использовать для управления и отмены этой операции. Такая функция может выглядеть так:
 */
//func loadData(from url: URL, completion: @escaping (Result) -> Void) -> Token

enum MissingData: Error {
    case test
}

//Цель данного примера - использвание специальных токенов для управления асинхронной роботой
class RequestToken {
    private weak var task: URLSessionDataTask?
    init(task: URLSessionDataTask) {
        self.task = task
    }
    func cancel() {
        self.task?.cancel()
    }
}

fileprivate class UserLoader {
    private let urlSession: URLSession
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    //Мы просто вернем стандартную таску, чтобы ее можно было покэнселять
    func loadUsers(matching query: String, completionHandler: @escaping (Result<[User]>) -> Void) -> URLSessionDataTask {
        let url = URL(string: query)
        let task = urlSession.dataTask(with: url!) { (data, _, error) in
            switch(data, error) {
            case (_, let error?):
                completionHandler(.error(error))
            case (let data?, _):
                do {
                    let users: [User] = try unbox(data: data)
                    completionHandler(.result(users))
                } catch {
                    completionHandler(.error(error))
                }
            case (nil, nil):
                completionHandler(.error(MissingData.test))
            }
        }
        task.resume()
        return task
    }

    //Использование функции уже с нужным токеном
    func loadUsersWithToken(matching query: String, completionHandler: @escaping (Result<[User]>) -> Void) -> RequestToken {
        let url = URL(string: query)
        let task = urlSession.dataTask(with: url!) { (data, _, error) in
            switch(data, error) {
            case (_, let error?):
                completionHandler(.error(error))
            case (let data?, _):
                do {
                    let users: [User] = try unbox(data: data)
                    completionHandler(.result(users))
                } catch {
                    completionHandler(.error(error))
                }
            case (nil, nil):
                completionHandler(.error(MissingData.test))
            }
        }
        task.resume()
        return RequestToken(task: task)
    }
}

class UserSearchViewController: UIViewController, UISearchBarDelegate {
    private let userLoader: UserLoader = UserLoader()
    private lazy var searchBar = UISearchBar()
    private var requestToken: RequestToken?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestToken?.cancel()
        requestToken = self.userLoader.loadUsersWithToken(matching: searchText) {
            switch $0 {
            case .error: break
            case .result: break
            }
        }
    }
}
