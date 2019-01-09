//
//  CreatingCustomCollections.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 09/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Removing optionals
/*
 Допустим, мы создаем приложение для продуктового магазина и хотим иметь пользовательский интерфейс,
 позволяющий пользователю отображать все продукты по категориям.
 Чтобы создать модель для такого пользовательского интерфейса,
 мы могли бы использовать Словарь, который использует Category в качестве своего ключевого типа
 и [Product] в качестве своего значения, например:
 */
fileprivate enum Category {
    case dairy, vegetables
}

fileprivate struct Product {
    let name: String
    let category: Category
}

fileprivate func test() {
    let products: [Category: [Product]] = [
            .dairy: [
                Product(name: "Milk", category: .dairy),
                Product(name: "Butter", category: .dairy)
            ],
            .vegetables: [
                Product(name: "Cucumber", category: .vegetables),
                Product(name: "Lettuce", category: .vegetables)
            ]]

    //Вынужденный код для работы со славарем
    if let dairyProducts = products[.dairy] {
        guard !dairyProducts.isEmpty else { return renderEmptyView() }
        render(dairyProducts)
    } else {
        renderEmptyView()
    }
}

fileprivate func render(_ priducts: [Product]) { }
fileprivate func renderEmptyView() { }

//Вставка новых продуктов, становится гораздо более сложной задачей:
fileprivate func add(_ product: Product, to products: [Category: [Product]]) {
    var products = products
    if var productInCategory = products[product.category] {
        productInCategory.append(product)
        products[product.category] = productInCategory
    } else {
        products[product.category] = [product]
    }
}

// MARK: - To be a collection
fileprivate struct ProductCollection {
    typealias DictionaryType = [Category: [Product]]

    private var products = DictionaryType()

    init(products: DictionaryType) {
        self.products = products
    }
}

extension ProductCollection: Collection {
    typealias Index = DictionaryType.Index
    typealias Element = DictionaryType.Element

    var startIndex: Index { return products.startIndex }
    var endIndex: Index { return products.endIndex }

    subscript(index: Index) -> Iterator.Element {
        get { return products[index] }
    }

    func index(after i: Index) -> Index {
        return products.index(after: i)
    }

    //Теперь мы можем использовать -
    /*
     for (category, productsInCategory) in products {}
     let categories = productCollection.map { $0.key }
     */

    /*
     Теперь, когда мы заложили основу для нашей коллекции, давайте начнем добавлять к ней некоторые API, которые позволят нам сделать наш код обработки продукта намного приятнее. Мы начнем с пользовательской перегрузки индекса, которая позволяет нам получать или устанавливать массив продуктов без необходимости работать с дополнительными функциями:
     */
    subscript(category: Category) -> [Product] {
        get { return products[category] ?? [] }
        set { products[category] = newValue }
    }

    //Давайте также добавим удобный API, чтобы легко вставить новый продукт в нашу коллекцию:
    mutating func insert(_ product: Product) {
        var productsInCategory = self[product.category]
        productsInCategory.append(product)
        self[product.category] = productsInCategory
    }
}

//Вставка новых продуктов теперь такая:
fileprivate func add(_ product: Product, to products: ProductCollection) {
    var products = products
    products.insert(product)
}

/*Становится выразимым буквальным
 Поскольку наша пользовательская коллекция - это просто обертка вокруг словаря, мы можем легко добавить поддержку для инициализации коллекции с использованием литерала словаря. Это позволит нам написать такой код:
 */

extension ProductCollection: ExpressibleByDictionaryLiteral {
    typealias Key = Category
    typealias Value = [Product]
    init(dictionaryLiteral elements: (Category, [Product])...) {
        for (category, productsInCategory) in elements {
            products[category] = productsInCategory
        }
    }
}

fileprivate func testInitProductCollection() {
    let _: ProductCollection = [
            .dairy: [
                Product(name: "Milk", category: .dairy),
                Product(name: "Butter", category: .dairy)
            ],
            .vegetables: [
                Product(name: "Cucumber", category: .vegetables),
                Product(name: "Lettuce", category: .vegetables)
            ]
    ]
}
