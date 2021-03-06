//
//  StructuralPatterns.swift
//  Patterns
//
//  Created by Vlad Gushchin on 14/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct StructuralPatterns {
    //декоратор
    static func decorator() {
        let bPizza = BulgerianPizza()
        let cPizza = CheesePizza(pizza: bPizza)
        let tPizza = TomatoPizza(pizza: cPizza)

        let array: [Pizza] = [bPizza, cPizza, tPizza]

        for element in array {
            dump(element)
        }
    }

    //адаптер
    static func adapter() {
        adapterTravelSimulation()
    }

    //фасад
    static func facade() {
        testFacade()
    }

    //Компоновщик
    static func composite() {
        testComposite()
    }

    //Заместитель
    static func proxy() {
        testProxy()
    }

    //Мост
    static func bridge() {
        testBridge()
    }
}
