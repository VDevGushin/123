//
//  UsingTokensToHandleAsyncSwiftCode.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 29/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*Обработка асинхронного кода предсказуемым, читаемым и простым в отладке способом может быть очень сложной. Это также является очень распространенным явлением, почти во всех современных кодовых базах есть части, которые сильно асинхронны - будь то загрузка данных по сети, локальная обработка больших наборов данных или любые другие вычислительные операции.
*/
// MARK: - Token-based APIs
/*Основная идея API на основе токенов заключается в том, что функция, которая запускает асинхронную или отложенную операцию, возвращает токен. Затем этот токен можно использовать для управления и отмены этой операции. Сигнатура такой функции может выглядеть так:*/
//func loadData(from url: URL, completion: @escaping (Result) -> Void) -> Token
/*
 Токены намного легче, чем, например, Futures & Promises - так как токен просто действует как способ отслеживания запроса, а не содержит весь запрос. Это также значительно облегчает их добавление в существующую кодовую базу вместо того, чтобы переписывать много асинхронного кода с использованием другого шаблона или раскрывать детали реализации.
 
 Так в чем же преимущество того, что функция, подобная приведенной выше, возвращает токен? Давайте посмотрим на пример, в котором мы строим контроллер представления, чтобы позволить пользователю искать других пользователей в нашем приложении:
 */
fileprivate enum Result<T> {
    case success(T)
    case error(Error?)
}

fileprivate enum ExampleError: Error {
    case noData
}

fileprivate struct User { }

fileprivate struct UserLoader {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func loadUsers(matching query: String,
                   completionHandler: @escaping (Result<[User]>) -> Void) {
        let url = URL(string: query)!
        let task = self.urlSession.dataTask(with: url) { data, _, error in
            switch (data, error) {
            case (_, let error?):
                completionHandler(.error(error))
            case (let data?, _):
                dump(data)
                completionHandler(.success([]))
            case (nil, nil):
                completionHandler(.error(ExampleError.noData))
            }
        }
        task.resume()
    }
}

fileprivate class UserSearchViewController: UIViewController, UISearchBarDelegate {
    private let userLoader: UserLoader
    private lazy var searchBar = UISearchBar(frame: .zero)

    init(loader: UserLoader) {
        self.userLoader = loader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.userLoader.loadUsers(matching: searchBar.text!) { [weak self] result in
            self?.reloadResultsView(with: result)
        }
    }

    private func reloadResultsView(with user: Result<[User]>) { }
}
/*
 Как вы можете видеть выше, все это выглядит довольно стандартно, но если вы когда-либо реализовывали такую функцию поиска по типу, как вы раньше - вы, вероятно, знаете, что там скрыта ошибка. Проблема в том, что скорость ввода символов в поле поиска не обязательно будет соответствовать скорости выполнения запросов. Это приводит к очень распространенной проблеме случайного рендеринга старых результатов, когда предыдущий запрос будет завершен после следующего.
 */

// MARK: - A token for every request
/*Что нам нужно сделать, чтобы избежать ошибок в нашем UserSearchViewController, это разрешить отмену любой текущей задачи. Есть несколько способов, которыми мы могли бы достичь этого. Один из вариантов - просто позволить самому UserLoader отслеживать текущую задачу с данными и отменять ее при каждом запуске новой:*/
fileprivate class UserLoaderWithToken {
    private let urlSession: URLSession
    private weak var currentTask: URLSessionDataTask?

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func loadUsers(matching query: String,
                   completionHandler: @escaping (Result<[User]>) -> Void) {
        self.currentTask?.cancel()

        let url = URL(string: query)!
        let task = self.urlSession.dataTask(with: url) { data, _, error in
            switch (data, error) {
            case (_, let error?):
                completionHandler(.error(error))
            case (let data?, _):
                dump(data)
                completionHandler(.success([]))
            case (nil, nil):
                completionHandler(.error(ExampleError.noData))
            }
        }
        task.resume()
        self.currentTask = task
    }
}

/*
 Вышеуказанное работает, и это абсолютно правильный подход. Однако это делает API немного менее очевидным - поскольку отмена теперь является обязательной и включается в реализацию. Это может привести к ошибкам в будущем, если UserLoader используется в другом контексте, в котором предыдущие запросы не должны быть отменены.
 
 Другой вариант - вернуть саму задачу с данными, когда вызывается loadUsers:
 */

fileprivate class UserLoaderWithReturnToken {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func loadUsers(matching query: String,
                   completionHandler: @escaping (Result<[User]>) -> Void) -> URLSessionDataTask {

        let url = URL(string: query)!
        let task = self.urlSession.dataTask(with: url) { data, _, error in
            switch (data, error) {
            case (_, let error?):
                completionHandler(.error(error))
            case (let data?, _):
                dump(data)
                completionHandler(.success([]))
            case (nil, nil):
                completionHandler(.error(ExampleError.noData))
            }
        }
        task.resume()
        return task
    }
}

/*Наконец, давайте попробуем решить эту проблему, используя вместо этого API на основе токенов. Для этого мы сначала создадим тип токена, который мы позже вернем при выполнении запроса:*/
fileprivate class RequestToken {
    private weak var task: URLSessionDataTask?
    init(task: URLSessionDataTask) {
        self.task = task
    }

    func cancel() {
        task?.cancel()
    }
}

fileprivate class UserLoaderWithMyRequestToken {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    @discardableResult
    func loadUsers(matching query: String,
                   completionHandler: @escaping (Result<[User]>) -> Void) -> RequestToken {

        let url = URL(string: query)!
        let task = self.urlSession.dataTask(with: url) { data, _, error in
            switch (data, error) {
            case (_, let error?):
                completionHandler(.error(error))
            case (let data?, _):
                dump(data)
                completionHandler(.success([]))
            case (nil, nil):
                completionHandler(.error(ExampleError.noData))
            }
        }
        task.resume()
        return RequestToken(task: task)
    }
}

// MARK: - Using a token to cancel an ongoing task
/*
 Время для последней части головоломки - фактически используя токен, чтобы отменить любой ранее незаконченный запрос, как только пользователь введет нового персонажа в панель поиска нашего контроллера представления.
 
 Для этого мы добавим свойство для хранения токена текущего запроса, и перед тем, как начать новый запрос, мы просто вызываем на нем метод cancel (). Наконец, поскольку мы ввели отмену, мы могли бы захотеть обновить наш код обработки результатов, чтобы он специально работал с URLError.cancelled, чтобы мы не отображали представление об ошибках всякий раз, когда мы отменяем старый запрос.
 
 Вот как выглядит финальная реализация:
 */
fileprivate class UserSearchViewControllerFinal: UIViewController, UISearchBarDelegate {
    private var userLoader: UserLoaderWithMyRequestToken?
    private lazy var searchBar = UISearchBar()
    private var requestToken: RequestToken?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestToken?.cancel()

        self.requestToken = self.userLoader?.loadUsers(matching: searchText) { [weak self] result in
            switch result {
            case .success(let users):
                self?.reloadResultsView(with: users)
            case .error(URLError.cancelled?):
                // Request was cancelled, no need to do any handling
                break
            case .error(let error):
                self?.handle(error)
            }
        }
    }
    
    private func reloadResultsView(with: [User]) {

    }
    
    private func handle(_ error: Error?) {

    }
}
