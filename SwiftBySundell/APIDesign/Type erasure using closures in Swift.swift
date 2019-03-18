//
//  Type erasure using closures in Swift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 18/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*
 Одной из вещей, которая делает Swift намного более безопасным и менее подверженным ошибкам, чем многие другие языки, является его продвинутая (и, в некотором смысле, не прощающая) система типов. Это одна из языковых функций, которая иногда может быть действительно впечатляющей и сделать вас намного более продуктивным, а в других случаях может вызывать разочарование.
 
 Сегодня я хотел бы выделить один тип ситуации, которая может возникнуть при работе с генериками в Swift, и как я обычно решаю ее, используя метод стирания типов, основанный на замыканиях.
 
 Допустим, мы хотим написать класс, который позволит нам загружать модель по сети. Поскольку мы не хотим дублировать этот класс для каждой модели в нашем приложении, мы решили сделать его универсальным, например:
 */
protocol Requestable {
    var requestURL: URL { get }
}

fileprivate enum Result<T> {
    case value(T?)
    case error(Error)
}

extension String: Requestable {
    var requestURL: URL {
        get {
            return URL(string: self)!
        }
    }
}

fileprivate struct NetworkService {
    func loadData(from: URL, then handler: (Result<Data>) -> Void) {
    }
}

fileprivate class ModelLoader: ModelLoading {
    typealias Model = String

    private let networkService: NetworkService = .init()

    func load(object: Model, completionHandler: (Result<Model>) -> Void) {

        networkService.loadData(from: object.requestURL) {
            switch $0 {
            case .error(let error):
                completionHandler(.error(error))
            case .value(let result):
                let result = try? JSONDecoder().decode(Model.self, from: result!)
                completionHandler(.value(result))
            }
        }
    }
}

/*Пока все хорошо, теперь у нас есть ModelLoader, который способен загружать любую модель, если она не может быть распакована, и может предоставить нам requestURL. Но мы также хотим, чтобы код, использующий загрузчик этой модели, был легко тестируемым, поэтому мы извлекаем его API в протокол:
 Poka vse khorosho, teper' u nas yest' Mode*/
fileprivate protocol ModelLoading {
    associatedtype Model
    func load(object: Model, completionHandler: (Result<Model>) -> Void)
}

/*Это, вместе с внедрением зависимостей, позволяет легко смоделировать наш API загрузки моделей в тестах. Но это сопряжено с некоторыми сложностями - в том случае, когда мы хотим использовать этот API, мы теперь должны называть его протоколом ModelLoading, с которым связано требование к типу. Это означает, что простой ссылки на ModelLoading недостаточно, поскольку компилятор не может вывести связанные с ним типы без дополнительной информации. Итак, пытаюсь сделать это:*/

class ViewController123: UIViewController {
    fileprivate init<T: ModelLoading>(modelLoader: T) where T.Model == MyModel {
        super.init(nibName: nil, bundle: nil)
    }

    //Not work, becouse
    //Protocol 'ModelLoading' can only be used as a generic constraint because it as Self or associated type requirements
//    fileprivate init(modelLoader: ModelLoading) {
//
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class MyModel: Decodable&Requestable {
    var requestURL: URL = URL(string: "1")!
}

/*Это работает, но так как мы также хотим иметь ссылку на наш загрузчик моделей в нашем контроллере представления, мы должны иметь возможность указать тип этого свойства. T известен только в контексте нашего инициализатора, поэтому мы не можем определить свойство с типом T, если не сделаем сам класс контроллера представления универсальным - что довольно быстро заставит нас упасть дальше и углубиться в пустоту универсальные классы везде.
 Вместо этого давайте используем стирание типа, чтобы мы могли сохранить какую-то ссылку на T, фактически не используя его тип. Это можно сделать, создав стертый тип, такой как класс-оболочка, например:*/


