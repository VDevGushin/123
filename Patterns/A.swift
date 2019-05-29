//
//  A.swift
//  Patterns
//
//  Created by Vlad Gushchin on 29/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

class A {
    //Возможные статические методы иди свойтсва
    static let a1: Int = 2
    static func makeSelf() -> A {
        return A()
    }

    //паблик свойства
    var a: Int?
    var b: Int?
    internal var c: Int?
    public var d: Int?

    //приват свойства
    private var ab: String?
    private var ab1: String?
    private var ab2: String?

    //конструкторы деструкторы
    init() { }
    deinit { }

    //Публичные методы класса или controller life
    func go() { }
    func stop() { }
    func viewdidLoad() { }

    //приватные методы методы класса или controller life(нажатия на кнопки, обработки нотификации)
    private func setupUI() { }
    private func setupNotifications() { }
    private func buttonDidTap() { }
    private func buttonDidTap1() { }
}

// MARK: - Расширение и зачем оно нужно
extension A: Equatable {
    static func == (lhs: A, rhs: A) -> Bool {
        return true
    }
}

// MARK: - Расширение с дополнительными классами
extension A {
    enum Strings: String {
        case a
    }
}

// MARK: - Расширение со статик методами
extension A {
    static func makeA() -> A {
        return A()
    }
}
