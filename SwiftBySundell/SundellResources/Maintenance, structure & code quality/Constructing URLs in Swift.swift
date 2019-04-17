//
//  Constructing URLs in Swift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 27/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate enum Result<T> {
    case success(T)
    case failure(Error)
}

fileprivate enum Sorting: String {
    case recency = "recency"
}

fileprivate struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }


    static func search(matching query: String,
                       sortedBy sorting: Sorting = .recency) -> Endpoint {
        return Endpoint(
            path: "/search/repositories",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "sort", value: sorting.rawValue)
            ]
        )
    }
}

fileprivate class DataLoader {
    enum DataLoaderError: Error {
        case invalidURL
        case network(Error?)
    }

    private var urlSession: URLSession!
    func request(_ endpoint: Endpoint,
                 then handler: @escaping (Result<Data>) -> Void) {
        guard let url = endpoint.url else {
            return handler(.failure(DataLoaderError.invalidURL))
        }

        let task = urlSession.dataTask(with: url) {
            data, _, error in

            let result = data.map(Result.success) ??
                .failure(DataLoaderError.network(error))

            handler(result)
        }

        task.resume()
    }
}

fileprivate func testDataLoader() {
    let dataLoader = DataLoader()
    dataLoader.request(.search(matching: "123")) { result in

    }
}

// MARK: - Static URLs
/*До сих пор мы имели дело с URL-адресами, которые были динамически созданы на основе пользовательского ввода или других данных, которые становятся известны только во время выполнения. Однако не все URL-адреса должны быть динамическими, и часто, когда мы выполняем запросы к таким вещам, как аналитика или конечные точки конфигурации - полный URL-адрес известен во время компиляции.
 
 Как мы видели при работе с динамическими URL-адресами, даже при использовании выделенных типов, таких как URLComponents, нам приходится работать с большим количеством опций. Мы просто не можем гарантировать, что все динамические компоненты будут действительными, поэтому, чтобы избежать сбоев и непредсказуемого поведения, мы вынуждены добавить пути кода, которые обрабатывают ноль случаев для недействительных URL-адресов.
 
 Однако это не относится к статическим URL-адресам. Со статическими URL-адресами мы либо правильно определили URL-адрес в нашем коде, либо наш код фактически неверен. Для таких URL-адресов необходимость иметь дело с дополнительными компонентами по всей нашей кодовой базе является немного ненужной, поэтому давайте посмотрим, как мы можем добавить отдельный способ создания этих URL-адресов - используя тип Swift StaticString.
 
 StaticString является менее известным «двоюродным братом» основного типа String. Основное различие между ними состоит в том, что StaticString не может быть результатом какого-либо динамического выражения - такого как интерполяция или конкатенация строк - всю строку необходимо определить как встроенный литерал. Внутренне Swift использует этот тип для таких вещей, как сбор имен файлов для утверждений и предварительных условий, но мы также можем использовать этот тип для создания инициализатора URL для полностью статических URL - например, так:*/
fileprivate extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        self = url
    }
}
/*Поначалу выполнение чего-то подобного может показаться противоречащим идее Swift о безопасности во время выполнения, но есть веская причина, почему мы хотим вызвать сбой здесь, а не иметь дело с опциями.
 
 Как мы уже рассматривали в разделе «Выбор правильного способа отказа в Swift», какая обработка ошибок, подходящая для любого конкретного случая, во многом зависит от того, вызвана ли ошибка ошибкой программиста или ошибкой выполнения. Поскольку определение недопустимого статического URL-адреса, безусловно, является ошибкой программиста, использование preconditionFailure, скорее всего, лучше всего подходит для этой проблемы. С такой обработкой мы получим четкое представление о том, что пошло не так, и, поскольку мы сейчас используем выделенный API для статических URL-адресов, мы можем даже добавить linting и статические проверки, чтобы сделать вещи еще более безопасными.
 
 Имея вышесказанное, мы можем легко определить необязательные URL-адреса, используя статический строковый литерал:*/
fileprivate let url = URL(staticString: "https://myapp.com/faq.html")
