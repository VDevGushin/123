//
//  Asynchronous completion handlers with Result type.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 19/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

//Помощник для URLSession для работы с result
fileprivate typealias URLHandler<T> = (Result <T, Error>) -> Void

fileprivate extension URLSession {
    func dataTask(with url: URL, completionHandler: @escaping URLHandler<Data>) {
        self.dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                completionHandler(.success(data ?? Data()))
            }
        }
    }
}

// Расширение для результата - чтобы сразу декодировать и возвращать себя же
fileprivate extension Result where Success == Data {
    func decodeResult<T: Decodable>(with decoder: JSONDecoder = .init()) -> Result<T, Error> {
        do {
            let data = try get()
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}

// Пример использования
fileprivate class History: Decodable { }

fileprivate class HistoryService {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func fetch(handler: @escaping URLHandler<History>) {
        self.session.dataTask(with: URL(string: "adgs")!) { result in
            handler(result.decodeResult())
        }
    }
}

