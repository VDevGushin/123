//
//  UsingAutoclosure .swift
//  MyWork
//
//  Created by Vladislav Gushin on 16/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate func animate(_ animation: @escaping () -> Void, duration: TimeInterval = 0.25) {
    UIView.animate(withDuration: duration, animations: animation)
}

fileprivate class Autoclosure {
    var view: UIView?
    func testAutoclosure() {
        if let view = view {
            animate({ view.frame.origin.y = 100 }, duration: 100)
        }
    }
}

//Добавим расширение на опционал для разворачивания через throw API
fileprivate extension Optional {
    func unwrapOrThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
}

fileprivate class TestOptional {
    struct ArgumetError {
        enum Er: Error {
            case test
        }
        static func testCase() -> Error {
            return Er.test
        }
    }
    let a: Int? = 3
    func test() {
        do {
            let value = try a.unwrapOrThrow(ArgumetError.Er.test)
            print(value)
        } catch {
            print(test)
        }
    }
}

//Работа с нетипизированным словарем
fileprivate class WorkWithDictAny {
    let dic = [String: Any]()
    func test() {
        //обычное использование
        let coins = (dic["numberOfCoins"] as? Int) ?? 100
        //Новое использование с автозамыканием
        let coins2 = dic.value(forKey: "numberOfCoins", defaultValue: 100)
    }
}

extension Dictionary where Value: Any {
    /*
     Функция serve(customer:) описанная выше принимает явное замыкание, которое возвращает имя клиента. Версия функции serve(customer:) ниже выполняет ту же самую операцию, но вместо использования явного замыкания, она использует автозамыкание, поставив маркировку при помощи атрибута @autoclosure. Теперь вы можете вызывать функцию, как будто бы она принимает аргумент String вместо замыкания. Аргумент автоматически преобразуется в замыкание, потому что тип параметра customerProvider имеет атрибут @autoclosure.
     */
    func value<T>(forKey key: Key, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self[key] as? T else {
            return defaultValue()
        }
        return value
    }
}

