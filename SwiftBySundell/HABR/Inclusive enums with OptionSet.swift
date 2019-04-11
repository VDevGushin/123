//
//  Inclusive enums with OptionSet.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Предположим, что у нас есть некоторый класс HistoryFetcher,
 который может извлекать данные из кэша или делать сетевой запрос или оба из них.
 Давайте начнем с описания очень простого перечисления источника.*/

fileprivate enum FetchSource {
    case memory
    case disk
    case remote
    case cache
    case all
}

/*Теперь мы можем работать с нашим методом извлечения истории,
 который будет принимать источник в качестве параметра и делать запрос в соответствии с источником.*/
fileprivate class History { }

fileprivate class HistoryFetcher {
    typealias Handler<T> = (Swift.Result<T, Error>) -> Void

    func fetch(from source: FetchSource = .all, then handler: @escaping Handler<History>) {
        switch source {
        case .memory:
            self.fetchMemory(handler: handler)
        case .disk:
            self.fetchDisk(handler: handler)
        case .remote:
            self.fetchRemote(handler: handler)
        case .cache:
            self.fetchMemory(handler: handler)
            self.fetchDisk(handler: handler)
        case .all:
            self.fetchMemory(handler: handler)
            self.fetchDisk(handler: handler)
            self.fetchRemote(handler: handler)
        }
    }

    private func fetchMemory(handler: Handler<History>) { }
    private func fetchDisk(handler: Handler<History>) { }
    private func fetchRemote(handler: Handler<History>) { }
}

/*Есть возможные недостатки этого подхода.
 
 Как только мы увеличим количество источников, мы должны добавить отдельный случай для этого и добавить его к обработке «всех» случаев.
 Мы не можем легко создать несколько объединений источников, таких как память и удаленные, дисковые и удаленные, и т. Д. Нам нужно много дополнительной логики, чтобы сделать это возможным.*/

/*OptionSet для спасения
 
 OptionSet - это протокол, который представляет типы битов, где отдельные биты представляют элементы набора. Принятие этого протокола в ваших пользовательских типах позволяет вам выполнять связанные с множеством операции, такие как тесты членства, объединения и пересечения этих типов.
 
 Протокол OptionSet очень прост. Все, что нам нужно, это свойство rawValue, которое должно соответствовать типу FixedWidthInteger. Так что в большинстве случаев мы можем использовать тип Int. Затем мы должны создать уникальные параметры, используя уникальную степень двух для каждого случая. Здесь мы можем использовать операторы сдвига битов. Давайте проведем рефакторинг нашего перечисления FetchSource для использования OptionSet.*/

fileprivate struct FetchSourceOptionSet: OptionSet {
    let rawValue: Int

    static let memory = FetchSourceOptionSet(rawValue: 1 << 0)
    static let disk = FetchSourceOptionSet(rawValue: 1 << 1)
    static let remote = FetchSourceOptionSet(rawValue: 1 << 2)

    static let cache: FetchSourceOptionSet = [.memory, .disk]
    static let all: FetchSourceOptionSet = [.cache, .remote]
}

/*Как вы видите выше, мы можем создать несколько членов объединения, которые содержат других членов. Это приносит реальную мощность при работе с этим OptionSets. Вот переработанная версия нашего класса HistoryFetcher.
*/

fileprivate class HistoryFetcherOptionSet {
    typealias Handler<T> = (Swift.Result<T, Error>) -> Void

    func fetch(from source: FetchSourceOptionSet = .all, then handler: @escaping Handler<History>) {
        if source.contains(.memory) {
            fetchMemory(handler: handler)
        }

        if source.contains(.disk) {
            fetchDisk(handler: handler)
        }

        if source.contains(.remote) {
            fetchRemote(handler: handler)
        }
    }

    private func fetchMemory(handler: Handler<History>) { }
    private func fetchDisk(handler: Handler<History>) { }
    private func fetchRemote(handler: Handler<History>) { }
}
