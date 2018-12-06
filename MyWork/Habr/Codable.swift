//
//  Codable.swift
//  MyWork
//
//  Created by Vladislav Gushin on 05/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

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


struct Bread {
    var type: String
}

protocol IBreadBuilder {
    var bread: Bread? { get set }
    func createBread()
    func buildWhiteBread()
    func buildBlackBread()
    func buildPadBread()
    func buildMacBread()
    func getBread() -> Bread?
    func buldSpecialBread()
}

class BreadBuilder: IBreadBuilder {
    var bread: Bread?

    func createBread() {
        self.bread = Bread(type: "хлеб")
    }

    func buildWhiteBread() {
        self.bread?.type += " белый"
    }

    func buildBlackBread() {
        self.bread?.type += " черный"
    }

    func buildPadBread() {
        self.bread?.type += " поджарка"
    }

    func buildMacBread() {
        self.bread?.type += " мак"
    }

    func buldSpecialBread() {
        self.buildWhiteBread()
        self.buildPadBread()
        self.buildMacBread()
    }

    func getBread() -> Bread? {
        return self.bread
    }
}

class VC: UIViewController {
    private let breadBulder: IBreadBuilder
    init(breadBulder: IBreadBuilder) {
        self.breadBulder = breadBulder
        breadBulder.createBread()
        breadBulder.buldSpecialBread()
        let bread = breadBulder.getBread()
        breadBulder.createBread()
        breadBulder.buldSpecialBread()
        let bread2 = breadBulder.getBread()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

