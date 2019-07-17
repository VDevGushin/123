//
//  Generalizing Swift code.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 16/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Решение о том, следует ли обобщать фрагмент кода для более чем одного варианта использования, может быть довольно сложным. Хотя адаптация функции или типа для использования в нескольких частях базы кода может быть отличным способом избежать дублирования кода, создание слишком универсальных вещей часто может привести к тому, что код будет трудно понять и поддерживать - поскольку в конечном итоге его необходимо выполнять перебор.
 
 На этой неделе давайте рассмотрим несколько ключевых факторов, которые могут помочь нам найти хороший баланс между возможностью повторного использования как можно большей части нашего кода, а также избегая усложнения или неоднозначности в процессе.*/

// MARK: - Starting with a specific implementation

/*В общем, отличный способ избежать чрезмерного обобщения кода - это создать начальную версию с учетом конкретного конкретного случая использования. Зачастую проще заставить новый кусок кода выполнять одну единственную вещь лучше, чем сосредоточиться на оптимизации его для повторного использования сразу - и до тех пор, пока мы стараемся разделить проблемы и разработать понятные API, мы всегда можем реорганизовать вещи, чтобы стать более многоразовые, когда это необходимо.
 
 Допустим, мы работаем над какой-либо формой приложения для электронной коммерции и что мы создали класс, который позволяет загружать продукт на основе его идентификатора, который выглядит примерно так:*/
fileprivate struct Product: Decodable {
    let id: UUID
    static func product(id: UUID) -> Product {
        return Product(id: id)
    }
}

fileprivate struct User: Decodable {
    let id: UUID
}

fileprivate struct Networking {
    func request(_ product: Product, then handle: (Result<Data, Error>) -> Void) { }
}

fileprivate class ProductLoader {
    typealias Handler = (Result<Product, Error>) -> Void

    private let networking: Networking
    private var cache = [UUID: Product]()

    init(networking: Networking) {
        self.networking = networking
    }

    func loadProduct(withID id: UUID, then handler: @escaping Handler) {
        // If a cached product exists, then return it directly instead
        // of performing a network request.
        if let product = self.cache[id] {
            return handler(.success(product))
        }

        // Load the product over the network, by requesting the
        // product endpoint with the given ID.
        networking.request(.product(id: id)) { [weak self] result in
            self?.handle(result, using: handler)
        }
    }
}

/*Глядя на приведенный выше пример кода, мы видим, что основная ответственность нашего ProductLoader состоит в том, чтобы проверить, был ли запрошенный продукт уже кэширован, и, если нет, запустить сетевой запрос на его загрузку. Как только ответ получен, он затем декодирует его результат в модель Product и кэширует его, используя метод private handle, который выглядит следующим образом:*/

private extension ProductLoader {
    func handle(_ result: Result<Data, Error>, using handler: Handler) {
        do {
            let product = try JSONDecoder().decode(
                Product.self,
                from: result.get()
            )

            cache[product.id] = product
            handler(.success(product))
        } catch {
            handler(.failure(error))
        }
    }
}

/*Хотя вышеприведенный класс на данный момент полностью ориентирован на продукт, в его работе нет ничего такого, что было бы уникальным для продуктов. На самом деле, наш ProductLoader должен быть способен только на три вещи:
 
- Проверьте, существует ли данная запись в кэше.
- Попросите внедренный экземпляр Networking запросить конечную точку.
- Расшифруйте данные ответа сети в модели.
 
 чГлядя на приведенный выше список, мы ничем не выделяемся в том, что мы хотели бы сделать только для продуктов - нам фактически необходимо выполнить точно такой же набор задач для загрузки любой модели в нашем приложении - таких как пользователи, кампании, поставщики. , и так далее. Итак, давайте посмотрим, как мы можем обобщить ProductLoader, позволяя использовать тот же код для загрузки любой модели.*/

// MARK: - Generalizing a core piece of logic

/*Что делает наш ProductLoader таким хорошим кандидатом для обобщения, помимо того факта, что нам понадобится одна и та же логика во многих частях нашей кодовой базы, состоит в том, что его реализация состоит только из задач очень общего назначения - таких как кэширование, работа в сети, и JSON-декодирование. Это должно позволить нам сохранить более или менее ту же реализацию, в то же время открывая наш API для большего количества вариантов использования.
 
 Давайте начнем с переименования нашего загрузчика продукта в ModelLoader и сделаем его универсальным, который может работать с любым типом модели, который соответствует Decodable. Мы позволим ему сохранить те же свойства и инициализатор, за исключением того факта, что теперь нам также потребуется функция, которая создает конечную точку для внедрения в качестве части инициализатора - поскольку разные модели могут загружаться с разных конечных точек сервера:*/

fileprivate struct Endpoint {
    let id: UUID

    static func product() -> ((UUID) -> Product) {
        return { id -> Product in
            return Product(id: id)
        }
    }

    static func user() -> ((UUID) -> User) {
        return { id -> User in
            return User(id: id)
        }
    }
}

fileprivate class ModelLoader<Model: Decodable> {
    typealias Handler = (Result<Model, Error>) -> Void

    private let networking: Networking1<Model>
    private let endpoint: (UUID) -> Model
    private var cache = [UUID: Model]()

    init(networking: Networking1<Model>,
        endpoint: @escaping (UUID) -> Model) {
        self.networking = networking
        self.endpoint = endpoint
    }

    func loadModel(withID id: UUID, then handler: @escaping Handler) {

        if let model = self.cache[id] {
            return handler(.success(model))
        }

        self.networking.request(endpoint(id)) { [weak self] result in
            self?.handle(result, using: handler, modelID: id)
        }
    }

    private func handle(_ result: Result<Data, Error>, using handler: Handler, modelID: UUID) {
        do {
            let model = try JSONDecoder().decode(Model.self, from: result.get())
            cache[modelID] = model
            handler(.success(model))
        } catch {
            handler(.failure(error))
        }
    }
}

fileprivate struct Networking1<Model: Decodable> {
    func request(_ product: Model, then handle: (Result<Data, Error>) -> Void) { }
}


private func test() {
    let productLoader = ModelLoader<Product>(
        networking: Networking1(),
        endpoint: Endpoint.product()
    )

    let productLoaderNew = ProductLoaderNew(networking: Networking1())

    let userLoader = ModelLoader<User>(
        networking: Networking1(),
        endpoint: Endpoint.user()
    )

    let userLoaderNew = UserLoaderNew(networking: Networking1())

    dump(productLoader)
    dump(productLoaderNew)
    dump(userLoader)
    dump(userLoaderNew)
}

// MARK: - Domain-specific conveniences

fileprivate typealias ProductLoaderNew = ModelLoader<Product>
fileprivate typealias UserLoaderNew = ModelLoader<User>

extension UserLoaderNew {
    convenience init(networking: Networking1<User>) {
        self.init(networking: networking,
            endpoint: Endpoint.user())
    }
}

extension ProductLoaderNew {
    convenience init(networking: Networking1<Product>) {
        self.init(networking: networking,
            endpoint: Endpoint.product())
    }
}

// MARK: - The power of shared abstractions

/*Преимущества обобщения кода не ограничиваются только уменьшением дублирования кода - обобщение базового набора логики также может быть отличным способом создания общей основы, на основе которой мы можем создавать мощные общие абстракции.
 
 Например, допустим, что мы продолжаем итерацию в нашем приложении, и в какой-то момент нам нужно загрузить несколько моделей за один раз в нескольких разных местах. Вместо того, чтобы писать дублирующую логику для каждого типа модели, так как у нас теперь есть наш универсальный ModelLoader, мы можем просто расширить его, добавив необходимый API-интерфейс, который позволяет нам загружать массив модели любого типа при любой последовательности идентификаторы:*/

extension ModelLoader {
    typealias MultiHandler = (Result<[Model], Error>) -> Void

    // We let any sequence be passed here, since some parts of
    // our code base might be storing IDs using an Array, while
    // others might be using a Dictionary, or a Set.
    func loadModels<S: Sequence>(withIDs ids: S, then handler: @escaping MultiHandler) where S.Element == UUID {
        var iterator = ids.makeIterator()
        var models = [Model]()

        func loadNext() {
            guard let nextID = iterator.next() else {
                return handler(.success(models))
            }

            loadModel(withID: nextID) { result in
                do {
                    try models.append(result.get())
                    loadNext()
                } catch {
                    handler(.failure(error))
                }
            }
        }
        loadNext()
    }
}

extension ModelLoader where Model == Product {
    func loadProducts(ids: [UUID], then handler: @escaping MultiHandler) {
        self.loadModels(withIDs: ids) { result in
            do {
                let products = try result.get()

                handler(.success(products))
            } catch {
                handler(.failure(error))
            }
        }
    }
}

// MARK: - We still need domain-specific types

fileprivate class ProductPurchasingController {
    typealias Handler = (Result<Void, Error>) -> Void

    private let loader: ProductLoader

    init(loader: ProductLoader) {
        self.loader = loader
    }

    func purchaseProduct(with id: UUID,
        then handler: @escaping Handler) {
        loader.loadProduct(withID: id) { result in
            // Perform purchase
        }
    }
}

