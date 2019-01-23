//
//  Iterator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 23/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Паттерн Итератор (Iterator) предоставляет абстрактный интерфейс для последовательного доступа ко всем элементам составного объекта без раскрытия его внутренней структуры.


 Ключевым моментом, который позволяет осуществить перебор коллекций с помощью foreach, является применения этими классами коллекций паттерна итератор, или проще говоря пары интерфейсов IEnumerable / IEnumerator. Интерфейс IEnumerator определяет функционал для перебора внутренних объектов в контейнере:
 */

fileprivate protocol IEnumerator {
    var current: Any { get set }
    func moveNext()
    func reset()
}

//А интерфейс IEnumerable использует IEnumerator для получения итератора для конкретного типа объекта:
fileprivate protocol IEnumerable {
    func getEnumerator() -> IEnumerator
}

/*
 Когда использовать итераторы?
    1)Когда необходимо осуществить обход объекта без раскрытия его внутренней структуры
    2)Когда имеется набор составных объектов, и надо обеспечить единый интерфейс для их перебора
    3)Когда необходимо предоставить несколько альтернативных вариантов перебора одного и того же объекта
 
 Формальное определение:
 */

// определяет интерфейс для создания объекта-итератора
fileprivate protocol Aggregate {
    func createIterator() -> Iterator
    var count: Int { get }
    subscript(index: Int) -> AnyObject { get set }
}

// определяет интерфейс для обхода составных объектов
fileprivate protocol Iterator {
    func first() -> AnyObject
    func next() -> AnyObject?
    func isDone() -> Bool
    func currentItem() -> AnyObject
}

// конкретная реализация Aggregate. Хранит элементы, которые надо будет перебирать
fileprivate class ConcreteAggregate: Aggregate {

    private var items = [AnyObject]()

    var count: Int {
        return self.items.count
    }

    func createIterator() -> Iterator {
        return ConcreteIterator(aggregate: self)
    }

    subscript(index: Int) -> AnyObject {
        get {
            return self.items[index]
        }
        set {
            self.items[index] = newValue
        }
    }
}

//онкретная реализация итератора для обхода объекта Aggregate. Для фиксации индекса текущего перебираемого элемента использует целочисленную переменную _current
fileprivate class ConcreteIterator: Iterator {
    private let aggregate: Aggregate
    private var current: Int = 0

    init(aggregate: Aggregate) {
        self.aggregate = aggregate
    }

    func first() -> AnyObject {
        return aggregate[0]
    }

    func next() -> AnyObject? {
        self.current += 1
        if current < aggregate.count {
            return aggregate[current]
        }
        return nil
    }

    func isDone() -> Bool {
        return current >= aggregate.count
    }

    func currentItem() -> AnyObject {
        return aggregate[current]
    }
}

// MARK: - Real work
//Теперь рассмотрим конкретный пример. Допустим, у нас есть классы книги и библиотеки:

fileprivate struct Book {
    var name: String
}

fileprivate protocol IBookIterator {
    func hasNext() -> Bool
    func next() -> Book?
}

fileprivate protocol IBookNumerable {
    func createNumerator() -> IBookIterator
    var count: Int { get }
    subscript(index: Int) -> Book { get set }
}

//И, допустим, у нас есть класс читателя, который хочет получить информацию о книгах, которые находятся в библиотеке. И для этого надо осуществить перебор объектов с помощью итератора:
fileprivate class Reader {
    func seeBooks(library: Library) {
        let iterator = library.createNumerator()
        while iterator.hasNext() {
            if let book = iterator.next() {
                print(book.name)
            }
        }
    }
}

fileprivate struct Library: IBookNumerable {
    private var books = [Book]()

    init() {
        books.append(Book(name: "Война и мир"))
        books.append(Book(name: "Отцы и дети"))
        books.append(Book(name: "Вишневый сад"))
    }

    func createNumerator() -> IBookIterator {
        return LibraryNumerator(self)
    }

    var count: Int {
        return books.count
    }

    subscript(index: Int) -> Book {
        get {
            return books[index]
        }
        set {
            books[index] = newValue
        }
    }
}

fileprivate class LibraryNumerator: IBookIterator {
    let aggregate: IBookNumerable
    var index: Int = 0

    init(_ aggregate: IBookNumerable) {
        self.aggregate = aggregate
    }


    func hasNext() -> Bool {
        return index < aggregate.count
    }

    func next() -> Book? {
        defer { self.index += 1 }
        return aggregate[self.index]
    }
}
