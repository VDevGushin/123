//
//  Pattern Matching with case let.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 20/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Сегодня мы поговорим о Pattern Matching, одной из моих любимых функций в Swift. Сопоставление с образцом - это проверка заданной последовательности токенов на наличие составляющих некоторого образца. У Swift есть специальное ключевое слово для применения Pattern Matching: case let. Давайте погрузимся в примеры.*/

// MARK: - Enums

fileprivate enum State<T> {
    case loading
    case loaded(T)
    case failed(Error)
}

fileprivate func test(state: State<String>) {
    switch state {
    case .failed(let error):
        dump(error)
    case .loading: print("loading")
    case .loaded(let shows) where shows.isEmpty: break
    case .loaded(let shows): dump(shows)
    }

    if case .loaded(let value) = state, value.isEmpty {
        print("test")
    }

    guard case let .loaded(shows) = state, shows.isEmpty else {
        return
    }
}

// MARK: - Optionals

fileprivate func testOptionals() {
    let value: Int? = 10
    switch value {
    case let value? where value > 10: break
    case let .some(value): dump(value)
    case .none: break
    }
}

// MARK: - Tuples

fileprivate func testTuples() {
    let auth = (username: "majid", password: "veryStrongPassword")

    switch auth {
    case ("admin", "admin"): break
    case let (_, password) where password.count < 6: break
    case let (username, password): break
    }
}

// MARK: - Loop
fileprivate func testLoop() {
    let stateHistory: [State<[String]>] = [.loaded([]), .loading]

    for case .loaded(let value) in stateHistory where !value.isEmpty {
        dump(value)
    }
}
