//
//  FactoryPatternToAvoidShared.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Help classes
fileprivate enum Result<T> {
    case error(Error)
    case value(T)
}

extension URL {
    static var todoList = URL(string: "!23")!
}
// MARK: -
/*
 Допустим, наше приложение содержит класс Request, который используется для выполнения запросов к нашему бэкэнду. Его реализация выглядит так:
 */

fileprivate class Request {
    enum State {
        case pending
        case ongoing
        case complete(Result<Data>)
    }

    let url: URL
    let parameters: [String: String]
    var state = State.pending

    init(url: URL, parameters: [String: String] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}

fileprivate struct DataLoader {
    func perform(_ request: Request, then handler: (Result<Data>) -> Void) {

    }
}

/*
 Итак, в чем проблема с вышеуказанной настройкой? Поскольку запрос содержит не только информацию о том, где и как должен выполняться запрос, но также и его состояние, мы можем в конечном итоге довольно легко обмениваться информацией о состоянии.
 
 Разработчик, не знакомый с деталями реализации Request, может предположить, что это простой тип значения (он выглядит так), который можно использовать повторно, например:
 */

fileprivate class TodoListViewController: UIViewController {
    private let request = Request(url: .todoList)
    private let dataLoader = DataLoader()

    func loadItems() {
        dataLoader.perform(request) { [weak self] in
            self?.render($0)
        }
    }

    private func render(_ result: Result<Data>) { }
}

/*
 С помощью описанной выше настройки мы можем легко оказаться в неопределенных ситуациях, когда loadItems вызывается несколько раз, прежде чем отложенный запрос будет выполнен (например, мы можем включить элемент управления поиском или механизм вытягивания для обновления, что может привести к много запросов). Так как все запросы выполняются с использованием одного и того же экземпляра, мы будем продолжать сбрасывать его состояние, что делает наш DataLoader очень запутанным 😬.
 
 Одним из способов решения этой проблемы является автоматическая отмена каждого ожидающего запроса при выполнении нового. Хотя это может решить нашу непосредственную проблему здесь, это может определенно вызвать другие, и сделать API намного более непредсказуемым и более сложным в использовании.
 */

/*
 Фабричные методы
 Вместо этого, давайте воспользуемся другим методом для решения вышеуказанной проблемы, используя фабричный метод, чтобы избежать связи состояния запроса с самим исходным запросом. Этот вид развязки обычно необходим для избежания общего состояния и является хорошей практикой для создания более предсказуемого кода в целом.
 Итак, как бы мы провели рефакторинг Request для использования фабричного метода? Мы начнем с введения типа StatefulRequest, который является подклассом Request, и переместим информацию о состоянии в него, например так:
 */
// MARK: - Factory methods

fileprivate class RequestV2 {
    let url: URL
    let parameters: [String: String]

    init(url: URL, parameters: [String: String] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}

fileprivate class StatefulRequest: RequestV2 {
    enum State {
        case pending
        case ongoing
        case completed(Result<Data>)
    }
    var state = State.pending
}

fileprivate extension RequestV2 {
    //Factory method
    func makeStateful() -> StatefulRequest {
        return StatefulRequest(url: url, parameters: parameters)
    }
}

/*Наконец, когда DataLoader начинает выполнять запрос, мы просто заставляем его каждый раз создавать новый StatefulRequest:*/

fileprivate class DataLoaderV2 {
    func perform(_ request: RequestV2) {
        let statefulRequest = request.makeStateful()
        perform(statefulRequest)
    }

    private func perform(_ request: StatefulRequest) {
        // Actually perform the request
    }
}


// MARK: - Factories

/*
 Далее, давайте посмотрим на другую ситуацию, когда фабричный шаблон может использоваться, чтобы избежать общего состояния, используя фабричные типы.
 
 Допустим, мы создаем приложение о фильмах, где пользователь может просматривать фильмы по категориям или получать рекомендации. У нас будет контроллер представления для каждого варианта использования, который использует одноэлементный MovieLoader для выполнения запросов к нашему бэкэнду, например так:
 */

fileprivate class CategoryViewController: UIViewController {
    class MovieLoader {
        static let shared = MovieLoader()
        private init() { }
        func loadMovies(in: Int, sectionIndex: Int, then handler: (Result<Data>) -> Void) {

        }

        private func cancelAllRequests() { }

        deinit {
            self.cancelAllRequests()
        }
    }

    // We paginate our view using section indexes, so that we
    // don't have to load all data at once
    func loadMovies(atSectionIndex sectionIndex: Int) {
        MovieLoader.shared.loadMovies(in: 1, sectionIndex: sectionIndex) {
            [weak self] result in
            self?.render(result)
        }
    }

    private func render(_ result: Result<Data>) { }
}

/*
 Поначалу использование синглтона может показаться проблематичным (это также очень распространено), но мы можем оказаться в довольно сложных ситуациях, если пользователь начнет просматривать наше приложение быстрее, чем запросы будут выполнены. Мы можем получить длинную очередь незавершенных запросов, что может сделать приложение очень медленным в использовании, особенно в плохих сетевых условиях.
 
 Здесь мы сталкиваемся с другой проблемой, которая является результатом совместного использования состояния (в данном случае очереди загрузки).
 
 Чтобы решить эту проблему, вместо этого мы будем использовать новый экземпляр MovieLoader для каждого контроллера представления. Таким образом, мы можем просто сделать так, чтобы каждый загрузчик отменял все ожидающие запросы, когда он был освобожден, чтобы очередь не была заполнена запросами, в которых мы больше не заинтересованы:
 */

/* Однако на самом деле нам не нужно вручную создавать новый экземпляр MovieLoader каждый раз, когда мы создаем контроллер представления. Вероятно, нам нужно внедрить такие вещи, как кэш, сеанс URL и другие вещи, которые нам придется постоянно передавать через контроллеры представления. Это звучит грязно, давайте вместо этого использовать фабрику!*/

fileprivate class MoveLoaderV2 {
    let session: URLSession
    init(session: URLSession) {
        self.session = session
    }

    private func cancelAllRequests() {
        self.session.invalidateAndCancel()
    }

    deinit {
        self.cancelAllRequests()
    }
}

fileprivate struct MovieLoaderFactory {
    private let session: URLSession

    func makeLoader() -> MoveLoaderV2 {
        return MoveLoaderV2(session: session)
    }
}

/*Затем мы инициализируем каждый из наших контроллеров представления с помощью MovieLoaderFactory, и, как только ему понадобится загрузчик, он лениво создает его с использованием фабрики. Как это:*/

fileprivate class CategoryViewControllerV2: UIViewController {
    private let loaderFactory: MovieLoaderFactory
    private lazy var loader : MoveLoaderV2 = loaderFactory.makeLoader()
    
    
    init(loaderFactory: MovieLoaderFactory) {
        self.loaderFactory = loaderFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
