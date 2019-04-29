//
//  Итератор.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 29/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Паттерн Итератор (Iterator) предоставляет абстрактный интерфейс для последовательного доступа ко всем элементам составного объекта без раскрытия его внутренней структуры.
 
 Когда использовать итераторы?
 
 Когда необходимо осуществить обход объекта без раскрытия его внутренней структуры
 
 Когда имеется набор составных объектов, и надо обеспечить единый интерфейс для их перебора
 
 Когда необходимо предоставить несколько альтернативных вариантов перебора одного и того же объекта
*/

// Интерфейс IEnumerator определяет функционал для перебора внутренних объектов в контейнере:
fileprivate protocol Enumerator {
    func moveNext() -> Bool
    var current: Any { get }
    func reset()
}

//А интерфейс IEnumerable использует IEnumerator для получения итератора для конкретного типа объекта:
fileprivate protocol Enumerable {
    func getEnumerator() -> Enumerator
}

//Пример

//Aggregate: определяет интерфейс для создания объекта-итератора
fileprivate protocol Aggregate: class {
    func createIterator() -> Iterator
    var count: Int { get }
    subscript (index: Int) -> Any { get set }
}

//Iterator: определяет интерфейс для обхода составных объектов
fileprivate protocol Iterator: class {
    func first() -> Any?
    func next() -> Any?
    func isDone() -> Bool
    func currentItem() -> Any
}

//ConcreteAggregate: конкретная реализация Aggregate. Хранит элементы, которые надо будет перебирать
fileprivate class ConcreteAggregate: Aggregate {
    private var collection = [Any]()

    func createIterator() -> Iterator {
        return ConcreteIterator(aggregate: self)
    }

    var count: Int {
        return collection.count
    }

    subscript(index: Int) -> Any {
        get {
            return self.collection[index]
        }
        set {
            self.collection.insert(newValue, at: index)
        }
    }
}

//ConcreteIterator: конкретная реализация итератора для обхода объекта Aggregate. Для фиксации индекса текущего перебираемого элемента использует целочисленную переменную _current
fileprivate class ConcreteIterator: Iterator {
    unowned private var aggregate: Aggregate
    private var current = 0

    init(aggregate: Aggregate) {
        self.aggregate = aggregate
    }

    func first() -> Any? {
        return self.aggregate[0]
    }

    func next() -> Any? {
        self.current += 1
        if self.current < self.aggregate.count {
            return self.aggregate[current]
        }
        return nil
    }

    func isDone() -> Bool {
        return self.current >= self.aggregate.count
    }

    func currentItem() -> Any {
        return self.aggregate[current]
    }
}

fileprivate func main() {
    let a = ConcreteAggregate()
    let iterator = a.createIterator()
    var item = iterator.first()
    while !iterator.isDone() {
        item = iterator.next()
    }
    dump(item)
}

//Теперь рассмотрим конкретный пример. Допустим, у нас есть классы книги и библиотеки:
fileprivate struct Book {
    let name: String
}

fileprivate protocol BookIterator {
    func hasNext() -> Bool
    func next() -> Book?
}

fileprivate protocol BookNumerable {
    func createIterator() -> BookIterator
    var count: Int { get }
    subscript (index: Int) -> Book { get }
}


fileprivate struct Library: BookNumerable {
    private var books: [Book] = []

    var count: Int { return self.books.count }

    func createIterator() -> BookIterator {
        return LibraryNumerator(library: self)
    }

    subscript(index: Int) -> Book {
        return self.books[index]
    }
}

fileprivate class LibraryNumerator: BookIterator {
    private let library: Library
    private var current = 0

    init(library: Library) {
        self.library = library
    }

    func hasNext() -> Bool {
        return self.current < self.library.count
    }

    func next() -> Book? {
        let next = self.current + 1
        if next < self.library.count {
            self.current += 1
            return self.library[next]
        }
        return nil
    }
}

//Читатель
fileprivate class Reader {
    func seeBooks(library: Library) {
        let iterator = library.createIterator()
        while iterator.hasNext() {
            let book = iterator.next()
            dump(book?.name)
        }
    }
}
