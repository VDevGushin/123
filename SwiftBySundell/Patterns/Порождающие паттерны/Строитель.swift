//
//  Строитель.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 19/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Строитель (Builder) - шаблон проектирования, который инкапсулирует создание объекта и позволяет разделить его на различные этапы.
 Когда использовать паттерн Строитель?
 1) Когда процесс создания нового объекта не должен зависеть от того, из каких частей этот объект состоит и как эти части связаны между собой
 2) Когда необходимо обеспечить получение различных вариаций объекта в процессе его создания
*/

fileprivate protocol Builder {
    func buildPartA()
    func buildPartB()
    func buildPartC()
    func getResult() -> Product
}

fileprivate struct Product {
    var parts: [String]
}

fileprivate class ConcreteBuilder: Builder {
    private var product = Product(parts: [])
    func buildPartA() {
        product.parts.append("A")
    }

    func buildPartB() {
        product.parts.append("B")
    }

    func buildPartC() {
        product.parts.append("C")
    }

    func getResult() -> Product {
        return product
    }
}

fileprivate class Director {
    private let builder: Builder
    init(builder: Builder) {
        self.builder = builder
    }

    func construct() {
        self.builder.buildPartA()
        self.builder.buildPartB()
        self.builder.buildPartC()
    }
}

/*Рассмотрим применение паттерна на примере выпечки хлеба. Как известно, даже обычный хлеб включает множество компонентов. Мы можем использовать для представления хлеба и его компонентов следующие классы:*/


///Хлеб и его инградиенты================================================
//Мука
fileprivate struct Flour {
    let sort: String
}
fileprivate struct Salt { }
// пищевые добавки
fileprivate struct Additives {
    let name: String
}

fileprivate struct Bread {
    var flour: Flour?
    var salt: Salt?
    var additives: Additives?

    func toString() -> String {
        var result = ""
        if let flour = self.flour {
            result += "\(flour.sort)\n"
        }
        if self.salt != nil {
            result += "Соль\n"
        }
        if let additives = self.additives {
            result += "Добавки \(additives.name)\n"
        }
        return result
    }
}
//================================================
//Производство хлеба================================================
//Пекарь
fileprivate struct Baker {
    func bake(builder: BreadBuilder) -> Bread {
        builder.setFlour()
        builder.setSalt()
        builder.setAdditives()
        let readyBread = builder.make()
        return readyBread
    }
}

fileprivate protocol BreadBuilder {
    init(bread: Bread)
    func setFlour()
    func setSalt()
    func setAdditives()
    func make() -> Bread
}

// строитель для ржаного хлеба
fileprivate class RyeBreadBuilder: BreadBuilder {
    private var bread: Bread
    required init(bread: Bread) {
        self.bread = bread
    }

    func setFlour() {
        self.bread.flour = Flour(sort: "Ржаная мука 1 сорт")
    }

    func setSalt() {
        self.bread.salt = Salt()
    }

    func setAdditives() {
        // not using
    }

    func make() -> Bread {
        return self.bread
    }
}

//// строитель для пшеничного хлеба
fileprivate class WheatBreadBuilder: BreadBuilder {
    private var bread: Bread
    required init(bread: Bread) {
        self.bread = bread
    }

    func setFlour() {
        self.bread.flour = Flour(sort: "Пшеничная мука высший сорт")
    }

    func setSalt() {
        self.bread.salt = Salt()
    }

    func setAdditives() {
        self.bread.additives = Additives(name: "Улучшитель хлебопекарный")
    }

    func make() -> Bread {
        return self.bread
    }
}
//================================================
//Использование================================================
fileprivate struct Program {
    func main() {
        let baker = Baker()
        var breadBuilder: BreadBuilder = RyeBreadBuilder(bread: Bread())
        let ryeBread = baker.bake(builder: breadBuilder)
        print(ryeBread.toString())
        breadBuilder = WheatBreadBuilder(bread: Bread())
        let whiteBread = baker.bake(builder: breadBuilder)
        print(whiteBread.toString())
    }
}
