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

fileprivate protocol House { }
fileprivate class PanelHouse: House { }
fileprivate class WoodHouse: House { }

fileprivate protocol Developer {
    var name: String { get set }
    init(name: String)
    func create() -> House
}

fileprivate class PanelDeveloper: Developer {
    var name: String

    required init(name: String) {
        self.name = name
    }

    func create() -> House {
        return PanelHouse()
    }
}

fileprivate class WoodDeveloper: Developer {
    var name: String

    required init(name: String) {
        self.name = name
    }

    func create() -> House {
        return WoodHouse()
    }
}

fileprivate func test() {
    var dev: Developer = PanelDeveloper(name: "ООО КирпичСтрой")
    let house2 = dev.create()

    dev = WoodDeveloper(name: "Частный застройщик")
    let house = dev.create()
    dump(house)
    dump(house2)
}
