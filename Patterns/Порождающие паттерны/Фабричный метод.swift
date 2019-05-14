//
//  Фабричный метод.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 09/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate protocol Product: class { }
fileprivate class ConcreteProductA: Product { }
fileprivate class ConcreteProductB: Product { }

fileprivate protocol Creator {
    func factoryMethod() -> Product
}

fileprivate class ConcreteCreatorA: Creator {
    func factoryMethod() -> Product {
        return ConcreteProductA()
    }
}

fileprivate class ConcreteCreatorB: Creator {
    func factoryMethod() -> Product {
        return ConcreteProductB()
    }
}

//========================================================================================
//========================================================================================
//========================================================================================
protocol House {
    var name: String { get set }
}
struct PanelHouse: House {
    var name: String
}
struct WoodHouse: House {
    var name: String
}

protocol Developer {
    var name: String { get set }
    init(name: String)
    func create() -> House
}

class PanelDeveloper: Developer {
    var name: String

    required init(name: String) {
        self.name = name
    }

    func create() -> House {
        return PanelHouse(name: self.name + " построил панельный дом")
    }
}

class WoodDeveloper: Developer {
    var name: String

    required init(name: String) {
        self.name = name
    }

    func create() -> House {
        return WoodHouse(name: self.name + " построил деревянный дом")
    }
}
