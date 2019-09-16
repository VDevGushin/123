//
//  Как использовать HTTP-кеш.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 12/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Эта статья была впервые опубликована в блоге Fabernovel.
 
 Одним из наиболее сложных вопросов в программировании является кеширование, потому что в проблеме нет серебряной пули, и каждое решение сопровождается компромиссами.
 
 В этой статье я хочу сосредоточиться на том, как мы достигли базового кэширования на большинстве наших экранов, используя кеш HTTP. Цель состояла в том, чтобы предоставить пользователю контент, даже если нет подключения к Интернету, как можно проще. Идея довольно проста: для всех запросов GET мы кешируем полученный ответ. Затем, если нет соединения, мы извлекаем предыдущий ответ из кеша и выводим предупреждение пользователю, информирующее, что данные могут быть устаревшими.*/

// MARK: - Caching the data
/*Основная идея состоит в том, чтобы кэшировать все ответы, которые мы получаем. Это можно сделать с помощью метода
 
 urlSession(_:dataTask:willCacheResponse:completionHandler:) of URLSessionDataDelegate.
 
 Документация метода:
Этот метод вызывается, только если NSURLProtocol, обрабатывающий запрос, решает кэшировать ответ. Как правило, ответы кэшируются только тогда, когда выполняются все следующие условия::
 
 Запрос для HTTP или HTTPS URL (или ваш собственный сетевой протокол, который поддерживает кэширование).
     Запрос был выполнен успешно (с кодом состояния в диапазоне 200–299).
     Предоставленный ответ пришел с сервера, а не из кэша.
     Политика кэширования конфигурации сеанса допускает кэширование.
     Предоставленная политика кэширования объекта URLRequest (если применимо) разрешает кэширование.
     Заголовки, связанные с кэшем в ответе сервера (если есть), разрешают кэширование.
     Размер ответа достаточно мал, чтобы вписаться в кеш. (Например, если вы предоставляете кеш диска, ответ должен быть не больше, чем около 5% от размера кеша диска.)
 
 Кэширование всех запросов требует, чтобы сервер возвращал следующие заголовки: либо заголовок Expires: либо заголовок Cache-Control: с параметром max-age или s-maxage.*/

//Using Alamofire

//fileprivate func test(urlSession: URLSession, urlSessionDataTask: URLSessionDataTask, cachedURLResponse: CachedURLResponse) -> CachedURLResponse? {
//// Clean the response if needed
//    let modifiedResponse = self?
//        .whipeAuthenticationHeaders(from: cachedURLResponse.response)
//        ?? cachedURLResponse.response
//
//// Store the current date with the cached response
//// (the date will be displayed later)
//    let date = NSDate()
//    let userInfo = [
//        Keys.cacheDateHeader: date.timeIntervalSince1970
//    ]
//
//// Return a new CachedURLResponse with the userInfo above
//    return CachedURLResponse(
//        response: modifiedResponse,
//        data: cachedURLResponse.data,
//        userInfo: userInfo,
//        storagePolicy: .allowed
//    )
//}

/*Механизм извлечения кэшированного ответа содержится в поведении. Поведение - это объект, который может выполнять код в разное время жизни запроса. Это не тема этой статьи, но вы можете узнать больше здесь. Просто помните, что в нашем случае мы хотим изменить ответ при сбое сетевого вызова и вернуть кешированные данные вместо ошибки*/
fileprivate protocol RequestBehavior {
    var additionalHeaders: [String: String] { get }
    func beforeSend()
    func afterSuccess(result: Any)
    func afterFailure(error: Error)
}

fileprivate extension RequestBehavior {
    var additionalHeaders: [String: String] {
        return [:]
    }

    func beforeSend() { }

    func afterSuccess(result: Any) { }

    func afterFailure(error: Error) { }
}

fileprivate class LoadFromCacheIfUnreachableBehavior: RequestBehavior {
    typealias Response = (data: Data?, response: URLResponse, error: Error?, request: URLRequest?, date: Date?)
    
    private let cache: URLCache
    
    init(cache: URLCache) {
        self.cache = cache
    }

    func modify(request: URLRequest, response: Response) -> Response {
        // Verify that we need to use the cache
        guard response.error != nil else {
            return response
        }
        
        // Get the request
        guard let urlRequest = response.request else {
            return response
        }

        // Get the response
        guard let cachedResponse = self.cache.cachedResponse(for: urlRequest),
            let httpURLResponse = cachedResponse.response as? HTTPURLResponse else {
                return response
        }

        // Get the date we saved earlier back from the cache
        var date: Date?
        if let userInfo = cachedResponse.userInfo,
            let cacheDate = userInfo["saveDate"] as? TimeInterval {
            date = Date(timeIntervalSince1970: cacheDate)
        }

        //Create the response from cached data
        do {
            let json = try JSONSerialization.data(withJSONObject: cachedResponse.data)
            let newResponse: Response = (json, httpURLResponse, nil, response.request, date)
            return newResponse
        } catch {
            return response
        }
    }
}

