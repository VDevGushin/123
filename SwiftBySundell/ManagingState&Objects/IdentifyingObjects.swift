//
//  IdentifyingObjects.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit


// MARK: - Equatable

/*Основной протокол, который часто используется для сравнения объектов и значений, является Equatable. Это протокол, с которым многие из вас, вероятно, уже знакомы, поскольку в любое время, когда вы хотите разрешить использование оператора == с типом, вам необходимо соответствовать ему. Вот пример:
 */

fileprivate struct Book {
    let title: String
    let author: String
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        guard lhs.title == rhs.title else {
            return false
        }
        guard lhs.author == rhs.author else {
            return false
        }
        return true
    }
}

// MARK: - Instance equatable
/*
 Хотя Equatable идеально подходит для работы со значениями (например, структурами или перечислениями), для объектов / классов это может быть не то, что вы ищете. Иногда вы хотите проверить, являются ли два объекта одним и тем же экземпляром. Для этого мы используем менее известного брата ==; ===, что позволяет сравнивать два объекта на основе их экземпляра, а не их значения.
 
 Давайте рассмотрим пример, в котором мы хотим перезагрузить InventoryManager каждый раз, когда ему назначается новый источник данных:
 */
fileprivate struct Item { }

fileprivate protocol InventoryDataSource: class {
    var numberOfItems: Int { get }
    func item(at index: Int) -> Item
}

fileprivate class InventoryManager {
    var dataSource: InventoryDataSource? {
        didSet {
            self.dataSourceDidChange(from: oldValue)
        }
    }

    private func dataSourceDidChange(from previousDataSource: InventoryDataSource?) {
        // We don't want to reload if the same data source is re-assigned
        guard previousDataSource !== dataSource else {
            return
        }
        self.reload()
    }

    private func reload() { }
}

// MARK: - Hashable

extension Book: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title.appending(author).hashValue)
    }
}

fileprivate class BookState {
    var inventory = [Book]()
    var uniqueBooks = Set<Book>()
    func add(_ book: Book) {
        // Inventory will contain all books, including duplicates
        inventory.append(book)

        // By using a set (which we can, now that 'Book' conforms to 'Hashable')
        // we can guarantee that 'uniqueBooks' only contains unique values
        uniqueBooks.insert(book)
    }
}

// MARK: - ObjectIdentifier
fileprivate protocol Renderable: class { }

fileprivate class RenderableWrapper {
    fileprivate let renderable: Renderable

    init(renderable: Renderable) {
        self.renderable = renderable
    }
}

extension RenderableWrapper: Equatable {
    static func == (lhs: RenderableWrapper, rhs: RenderableWrapper) -> Bool {
        return lhs.renderable === rhs.renderable
    }
}

extension RenderableWrapper: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(renderable).hashValue)
    }
}

fileprivate class Renderer {
    private var objectsNeedingRendering = Set<RenderableWrapper>()

    func enqueue(_ renderable: Renderable) {
        let wrapper = RenderableWrapper(renderable: renderable)
        objectsNeedingRendering.insert(wrapper)
    }

    func screenDidDraw() {
        // Start by emptying the queue
        let objects = objectsNeedingRendering
        objectsNeedingRendering = []

        // Render each object
        for _ in objects {
            // object.render(in: context)
        }
    }
}
