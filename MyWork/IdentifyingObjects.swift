//
//  IdentifyingObjects.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
/*
 Conclusion
 When using values, Equatable and Hashable is probably the way to go in terms of identity - since you are more comparing a normalized representation of a value, rather than a unique instance. However, when dealing with objects, using some of the techniques from this post can make your APIs easier to use, and in result decrease complexity and increase stability.
 
 Instead of requiring implementors to conform to Equatable, or exposing some form of unique identifier (like a UUID), you can use techniques like the === operator and the ObjectIdentifier type to quickly and uniquely identify objects without much extra code.
 */

// MARK: - Equatable
private struct Book {
    let title: String
    let author: String
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        guard lhs.title == rhs.title else { return false }
        guard lhs.author == rhs.author else { return false }
        return true
    }
}

// MARK: - Check for same instance
private struct Item { }

private protocol InventoryDataSource: class {
    var numberOfItems: Int { get }
    func item(at index: Int) -> Item
}

private class InventoryManager {
    var dataSource: InventoryDataSource? {
        didSet {
            dataSourceDidChange(from: oldValue)
        }
    }

    private func dataSourceDidChange(from previousDataSource: InventoryDataSource?) {
        guard previousDataSource !== dataSource else { return }
        reload()
    }

    func reload() { }
}

// MARK: - Hashable
extension Book: Hashable {
    var hashValue: Int {
        return title.appending(author).hashValue
    }
}
//Using

private class BookStore {
    var inventory = [Book]()
    var uniqueBooks = Set<Book>()

    func add(_ book: Book) {
        inventory.append(book)
        uniqueBooks.insert(book)//using hashable
    }
}

// MARK: - Hashable for protocol types
private class Renderer {

    func enqueue(_ circle: Circle) { }
}

protocol Renderable: class {
    func render(in context: CGContext)
}

private class Circle {
    weak var renderer: Renderer?
    var radius: CGFloat {
        didSet { renderer?.enqueue(self) }
    }
    var strokeColor: UIColor {
        didSet { renderer?.enqueue(self) }
    }
    init(radius: CGFloat, strokeColor: UIColor) {
        self.radius = radius
        self.strokeColor = strokeColor
    }
}

extension Circle: Renderable {
    func render(in context: CGContext) {

    }
}

// MARK: - ObjectIdentifier

class RenderableWrapper {
    fileprivate let renderable: Renderable

    init(renderable: Renderable) {
        self.renderable = renderable
    }

    func render(in context: CGContext) {
        renderable.render(in: context)
    }
}

extension RenderableWrapper: Equatable, Hashable {
    static func == (lhs: RenderableWrapper, rhs: RenderableWrapper) -> Bool {
        return lhs.renderable === rhs.renderable
    }

    var hashValue: Int {
        return ObjectIdentifier(renderable).hashValue
    }
}

class RendererV1 {
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
        for object in objects {
          //  let context = makeContext()
           // object.render(in: context)
        }
    }
}
