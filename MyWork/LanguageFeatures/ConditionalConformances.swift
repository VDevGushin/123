//
//  ConditionalConformances.swift
//  MyWork
//
//  Created by Vladislav Gushin on 30/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

///пример работы с массивом (условное соответсвие)
fileprivate protocol ScoreConvertible {
    func computeScore() -> Int
}
fileprivate class Level: ScoreConvertible {
    func computeScore() -> Int {
        return id.count
    }

    let id: String
    init(id: String) {
        self.id = id
    }
}

fileprivate class Test1 {
    func test () {
        let levels = [Level(id: "water-0"), Level(id: "water-1")]
        let score = levels.computeScore()
        //с нашим рашсриением мы даже можем проедать тоже самое с вложенными типами
        let worlds = [
            [Level(id: "water-0"), Level(id: "water-1")],
            [Level(id: "sand-0"), Level(id: "sand-1")],
            [Level(id: "lava-0"), Level(id: "lava-1")]
        ]
        let totalScore = worlds.computeScore()
    }
}

//Массив соотвествует типу
extension Array: ScoreConvertible where Element: ScoreConvertible {
    func computeScore() -> Int {
        return reduce(0) { result, element in
            result + element.computeScore()
        }
    }
}

//============================================================Пример2 - Multipart requests==============================
class Article { }

fileprivate protocol Request {
    associatedtype Response
    typealias Handler = (Result<Response>) -> Void
    func perform(then handler: @escaping Handler)
}

struct ArticleRequest: Request {
    typealias Response = [Article]
    let dataLoader: DataLoader
    let category: String

    func perform(then handler: @escaping (Result<[Article]>) -> Void) {
        let endPoint = "Endpoint.articles(category)"
        dataLoader.loadData(from: URL(string: endPoint)!) { result in
            //handler(result)
        }
    }
}

extension Dictionary: Request where Value: Request {
    typealias Response = [Key: Value.Response]

    func perform(then handler: @escaping Handler) {
        var responses = [Key: Value.Response]()
        let group = DispatchGroup()

        for (key, request) in self {
            group.enter()

            request.perform { response in
                switch response {
                case .result(let value):
                    responses[key] = value
                    group.leave()
                case .error(let error):
                    handler(.error(error))
                }
            }
        }

        group.notify(queue: .main) {
            handler(.result(responses))
        }
    }
}

struct TestTTT {
    let dataLoader: DataLoader
    func loadArticles() {
        let requests: [String: ArticleRequest] = [
            "news": ArticleRequest(dataLoader: dataLoader, category: "news"),
            "sports": ArticleRequest(dataLoader: dataLoader, category: "sports")
        ]

        requests.perform { result in
            switch result {
            case .result(let articles):
                for (category, articles) in articles {
                    //  self?.render(articles, in: category)
                }
            case .error(let error): break
                // self?.handle(error)
            }
        }
    }
}

