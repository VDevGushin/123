//
//  Codable.swift
//  MyWork
//
//  Created by Vladislav Gushin on 05/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

/*
 {
 "title": "Nike shoes",
 "price": 10.5,
 "quantity": 1
 }
 */

private struct Product: Codable {
    var title: String
    var price: Double
    var quantity: Int

    enum CodingKeys: String, CodingKey {
        case title
        case price
        case quantity
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(price, forKey: .price)
        try container.encode(quantity, forKey: .quantity)
    }
}

//Using
func test() {
    let data = Data()
    let product: Product = try! JSONDecoder().decode(Product.self, from: data)

    let productObject = Product(title: "Cheese", price: 10.5, quantity: 1)
    let encodedData = try? JSONEncoder().encode(productObject)
}
