//
//  Using @autoclosure when designing.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 19/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*Атрибут @autoclosure от Swift позволяет вам определять аргумент, который автоматически оборачивается в замыкание. Он в основном используется для того, чтобы отложить выполнение (потенциально дорогого) выражения до момента, когда оно действительно необходимо, вместо того, чтобы делать это непосредственно при передаче аргумента.
 
 Одним из примеров того, когда это используется в стандартной библиотеке Swift, является функция assert. Поскольку утверждения запускаются только в отладочных сборках, нет необходимости оценивать выражение, которое утверждается в сборке выпуска. Вот где @autoclosure входит:*/

fileprivate func assertCustom(_ expression: @autoclosure () -> Bool, _ message: @autoclosure () -> String, isDebug: Bool = false) {
    guard isDebug else {
        return
    }
    if !expression() {
        assertionFailure(message())
    }
}

fileprivate func testAssertCustom() {
    func someCondition() -> Bool {
        return false
    }
    assertCustom({ someCondition() }(), { "Hey, it failed!" }())
    assertCustom(someCondition(), "Hey it failed!")
}

// MARK: - Inlining assignments
/*@Autoclosure позволяет встроить выражения в вызов функции. Это позволяет нам делать такие вещи,
 как передача выражений присваивания в качестве аргумента. Давайте посмотрим на пример, где это может быть полезно.
 На iOS вы обычно определяете анимации вида, используя этот API:*/

fileprivate func animate(_ animation: @autoclosure @escaping () -> Void,
    duration: TimeInterval = 0.25) {
    UIView.animate(withDuration: duration, animations: animation)
}

fileprivate func testAnimate() {
    let view = UIView(frame: .zero)
    animate(view.frame.origin.y = 13)
}

// MARK: - Passing errors as expressions
fileprivate enum ArgumentError: Error {
    case missingName
}

fileprivate extension Optional {
    func unwrapOrThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
}

fileprivate func testUnwrapOrThrow() {
    func argument(at: String) -> Int? {
        return Int(at)
    }

    let number = try? argument(at: "123").unwrapOrThrow(ArgumentError.missingName)
    dump(number)
}

// MARK: - Type inference using default values
fileprivate extension Dictionary where Value == Int {
    func value<T>(forKey key: Key, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self[key] as? T else {
            return defaultValue()
        }
        return value
    }
}

fileprivate func usingDefaultValues() {
    let dictionary: [String: Int] = [:]

    let coins = dictionary["numberOfCoins"] ?? 100

    let coins1: Int = dictionary.value(forKey: "numberOfCoins", defaultValue: 100)
    print(coins, coins1)
}
