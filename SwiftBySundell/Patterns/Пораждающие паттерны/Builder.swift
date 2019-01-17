//
//  Builder.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 16/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

//Строитель (Builder) - шаблон проектирования, который инкапсулирует создание объекта и позволяет разделить его на различные этапы.

/*
 Когда использовать паттерн Строитель?
 
    1)Когда процесс создания нового объекта не должен зависеть от того, из каких частей этот объект состоит и как эти части связаны между собой
 
    2)Когда необходимо обеспечить получение различных вариаций объекта в процессе его создания
 */

//Формальное определение:

//распорядитель - создает объект, используя объекты Builder
fileprivate class Director {
    let builder: Builder

    init(builder: Builder) {
        self.builder = builder
    }

    func construct() {
        builder.buildPartA()
        builder.buildPartB()
        builder.buildPartC()
    }
}

//Product: представляет объект, который должен быть создан. В данном случае все части объекта заключены в списке parts.
fileprivate struct Product {
    var parts = [String]()
    mutating func add(part: String) {
        self.parts.append(part)
    }
}

//определяет интерфейс для создания различных частей объекта Product
fileprivate protocol Builder {
    func buildPartA()
    func buildPartB()
    func buildPartC()
    func buildPartD()
    func getResult() -> Product
}

//конкретная реализация Buildera. Создает объект Product и определяет интерфейс для доступа к нему
fileprivate class ConcreteBuilder: Builder {
    lazy var product = Product()

    func buildPartA() {
        product.add(part: "part A")
    }

    func buildPartB() {
        product.add(part: "part B")
    }

    func buildPartC() {
        product.add(part: "part C")
    }

    func buildPartD() {
        product.add(part: "part D")
    }

    func getResult() -> Product {
        return self.product
    }
}

//Рассмотрим применение паттерна на примере выпечки хлеба. Как известно, даже обычный хлеб включает множество компонентов. Мы можем использовать для представления хлеба и его компонентов следующие классы:

//мука
fileprivate struct Flour {
    let sort: String
}

//соль
fileprivate struct Salt { }

//пищевые добавки
fileprivate struct Additives { }

fileprivate class Bread {
    var flour: Flour?
    var salt: Salt?
    var additives: Additives?

    func toString() -> String {
        var result = String()
        if self.flour != nil {
            result += "flour_"
        }
        if self.salt != nil {
            result += "salt_"
        }
        if self.additives != nil {
            result += "additives_"
        }
        return result
    }
}
//Хлеб может иметь различную комбинацию компонентов: ржаной и пшеничной муки, соли, пищевых добавок. И нам надо обеспечить выпечку разных сортов хлеба. Для разных сортов хлеба может варьироваться конкретный набор компонентов, не все компоненты могут использоваться. И для этой задачи применим паттерн Builder:

//// абстрактный класс строителя

fileprivate class Program {
    func main() {
        let baker = Backer()
        var breadBuilder: BreadBuilder = RyeBreadBuilder()
        let ryeBread = baker.bake(breadBuilder: breadBuilder)

        breadBuilder = WheatBreadBuilder()
        let whiteBread = baker.bake(breadBuilder: breadBuilder)
        dump(ryeBread)
        dump(whiteBread)
    }
}

fileprivate protocol BreadBuilder: class {
    var bread: Bread { get set }
    func createBread()
    func setFlour()
    func setSalt()
    func setAdditives()
}

extension BreadBuilder {
    func createBread() {
        self.bread = Bread()
    }
}

//Пекарь
fileprivate class Backer {
    func bake(breadBuilder: BreadBuilder) -> Bread {
        breadBuilder.createBread()
        breadBuilder.setSalt()
        breadBuilder.setFlour()
        breadBuilder.setAdditives()
        return breadBuilder.bread
    }
}


// строитель для ржаного хлеба
fileprivate class RyeBreadBuilder: BreadBuilder {
    var bread: Bread

    init() {
        self.bread = Bread()
    }

    func setFlour() {
        self.bread.flour = Flour(sort: "Ржаная мука")
    }

    func setSalt() {
        self.bread.salt = Salt()
    }

    func setAdditives() {
        // не используется
    }
}

// строитель для ржаного хлеба
fileprivate class WheatBreadBuilder: BreadBuilder {
    var bread: Bread

    init() {
        self.bread = Bread()
    }

    func setFlour() {
        self.bread.flour = Flour(sort: "Пшеничная мука")
    }

    func setSalt() {
        self.bread.salt = Salt()
    }

    func setAdditives() {
        // не используется
    }
}
