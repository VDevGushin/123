//
//  СustomСollections.swift
//  MyWork
//
//  Created by Vladislav Gushin on 11/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
//TODO: - bad impl
private enum Category {
    case dairy, vegetables
}

private struct Product {
    let category: Category
    let name: String
}

fileprivate final class ShopingCard {
    private (set) var products = [Category: [Product]]()
    func add(_ product: Product) {
        if var productInCategory = products[product.category] {
            productInCategory.append(product)
            products[product.category] = productInCategory
        } else {
            products[product.category] = [product]
        }
    }
}

//TODO: - to be collected
private struct ProductCollection: Collection, ExpressibleByDictionaryLiteral {
    typealias DictionaryType = [Category: [Product]]
    typealias Index = DictionaryType.Index
    typealias Element = DictionaryType.Element
    private var products = DictionaryType()
    typealias Key = Category
    typealias Value = [Product]
    var startIndex: ProductCollection.DictionaryType.Index { return products.startIndex }
    var endIndex: ProductCollection.DictionaryType.Index { return products.endIndex }

    subscript(index: Index) -> Iterator.Element {
        return products[index]
    }

    init() { }

    init(products: DictionaryType) {
        self.products = products
    }

    func index(after i: Index) -> Index {
        return products.index(after: i)
    }

    init(dictionaryLiteral elements: (Category, [Product])...) {
        for (category, productsInCategory) in elements {
            products[category] = productsInCategory
        }
    }

    subscript(category: Category) -> [Product] {
        get {
            return products[category] ?? []
        }
        set {
            products[category] = newValue
        }
    }

    mutating func insert(_ product: Product) {
        var productInCategory = self[product.category]
        productInCategory.append(product)
        self[product.category] = productInCategory
    }
}

//Using
private class ShoppingCart {
    private(set) var products = ProductCollection()
    func add(product: Product) {
        products.insert(product)
    }
}
