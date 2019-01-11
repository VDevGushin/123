//
//  FactoryMethod.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*
 Фабричный метод (Factory Method) - это паттерн, который определяет интерфейс для создания объектов некоторого класса, но непосредственное решение о том, объект какого класса создавать происходит в подклассах.
 
 Когда надо применять паттерн:
    1)Когда заранее неизвестно, объекты каких типов необходимо создавать
 
    2)Когда система должна быть независимой от процесса создания новых объектов и расширяемой: в нее можно легко вводить новые классы, объекты которых система должна создавать.
 
    3)Когда создание новых объектов необходимо делегировать из базового класса классам наследникам
 */

//Абстрактный класс Product определяет интерфейс класса, объекты которого надо создавать.
fileprivate protocol Product { }

//Конкретные классы ConcreteProductA и ConcreteProductB представляют реализацию класса Product.
//Таких классов может быть множество
fileprivate class ConcreteProductA: Product { }
fileprivate class ConcreteProductB: Product { }

//Абстрактный класс Creator определяет абстрактный фабричный метод factoryMethod(), который возвращает объект Product.
fileprivate protocol Creator {
    func factoryMethod() -> Product
}

/*
 Конкретные классы ConcreteCreatorA и ConcreteCreatorB - наследники класса Creator, определяющие свою реализацию метода FactoryMethod(). Причем метод FactoryMethod() каждого отдельного класса-создателя возвращает определенный конкретный тип продукта. Для каждого конкретного класса продукта определяется свой конкретный класс создателя.
 Таким образом, класс Creator делегирует создание объекта Product своим наследникам. А классы ConcreteCreatorA и ConcreteCreatorB могут самостоятельно выбирать какой конкретный тип продукта им создавать.
 */
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

/*
 Теперь рассмотрим на реальном примере. Допустим, мы создаем программу для сферы строительства. Возможно, вначале мы захотим построить многоэтажный панельный дом. И для этого выбирается соответствующий подрядчик, который возводит каменные дома. Затем нам захочется построить деревянный дом и для этого также надо будет выбрать нужного подрядчика:
*/

//интерфейс строительной компании
fileprivate protocol Developer {
    var name: String { get set }
    func create() -> House
}

fileprivate class PanelDeveloper: Developer {
    var name: String
    init(name: String) {
        self.name = name
    }

    func create() -> House {
        return PanelHouse()
    }
}

fileprivate class WoodDeveloper: Developer {
    var name: String
    init(name: String) {
        self.name = name
    }

    func create() -> House {
        return WoodHouse()
    }
}


//интерфейс дома
fileprivate protocol House { }
//панельный дом
fileprivate class PanelHouse: House { }
//дом из дерева
fileprivate class WoodHouse: House { }

fileprivate func MAIN() {
    let dev = PanelDeveloper(name: "ООО КирпичСтрой")
    let panelHouse = dev.create()

    let dev2 = WoodDeveloper(name: "Частный застройщик")
    let woodHouse = dev2.create()

    dump(panelHouse)
    dump(woodHouse)
}

/*
 В качестве абстрактного класса Product здесь выступает класс House. Его две конкретные реализации - PanelHouse и WoodHouse представляют типы домов, которые будут строить подрядчики. В качестве абстрактного класса создателя выступает Developer, определяющий абстрактный метод Create(). Этот метод реализуется в классах-наследниках WoodDeveloper и PanelDeveloper. И если в будущем нам потребуется построить дома какого-то другого типа, например, кирпичные, то мы можем с легкостью создать новый класс кирпичных домов, унаследованный от House, и определить класс соответствующего подрядчика. Таким образом, система получится легко расширяемой. Правда, недостатки паттерна тоже очевидны - для каждого нового продукта необходимо создавать свой класс создателя.
 */
