//
//  GeneratingPatterns.swift
//  Patterns
//
//  Created by Vlad Gushchin on 14/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct GeneratingPatterns {
    //Фабричный метод
    static func testFactoryMethod() {
        var dev: Developer = PanelDeveloper(name: "ООО КирпичСтрой")
        let house2 = dev.create()
        dev = WoodDeveloper(name: "Частный застройщик")
        let house = dev.create()
        dump(house)
        dump(house2)
    }
    //Абстрактная фабрика
    static func testAbstractFactory() {
        let elf = Hero(factory: ElfFactory())
        elf.hit()
        elf.run()
        let voin = Hero(factory: VoinFactory())
        voin.hit()
        voin.run()
    }
    //Прототип
    static func testPrototype() {
        let circle = Circle(radius: 12, point: CGPoint(x: 2.0, y: 2.0))
        let clone = circle.clone()
        dump(clone)
    }
    //Строитель
    static func testBuilder() {
        let baker = Baker()
        var breadBuilder: BreadBuilder = RyeBreadBuilder(bread: Bread())
        let ryeBread = baker.bake(builder: breadBuilder)
        print(ryeBread.toString())
        breadBuilder = WheatBreadBuilder(bread: Bread())
        let whiteBread = baker.bake(builder: breadBuilder)
        print(whiteBread.toString())
    }
}

