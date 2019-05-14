//
//  Декоратор (Decorator).swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 14/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Декоратор (Decorator) представляет структурный шаблон проектирования, который позволяет динамически подключать к объекту дополнительную функциональность.
 
 Для определения нового функционала в классах нередко используется наследование. Декораторы же предоставляет наследованию более гибкую альтернативу, поскольку позволяют динамически в процессе выполнения определять новые возможности у объектов.
 
 Когда следует использовать декораторы?
 
 Когда надо динамически добавлять к объекту новые функциональные возможности. При этом данные возможности могут быть сняты с объекта
 
 Когда применение наследования неприемлемо. Например, если нам надо определить множество различных функциональностей и для каждой функциональности наследовать отдельный класс, то структура классов может очень сильно разрастись. Еще больше она может разрастись, если нам необходимо создать классы, реализующие все возможные сочетания добавляемых функциональностей.
 
 Схематически шаблон "Декоратор" можно выразить следующим образом:*/

//абстрактный класс, который определяет интерфейс для наследуемых объектов
fileprivate protocol Component: class {
    func operation()
}

//ConcreteComponent: конкретная реализация компонента, в которую с помощью декоратора добавляется новая функциональность
fileprivate class ConcreteComponent: Component {
    func operation() { }
}

fileprivate protocol Decorator: Component {
    var component: Component? { get set }
    func setComponent(component: Component)
    func operation()
}

extension Decorator {
    func operation() {
        if let component = self.component {
            component.operation()
        }
    }
}

fileprivate class ConcreteDecoratorA: Decorator {
    var component: Component?

    func setComponent(component: Component) {
        self.component = component
    }
}


fileprivate class ConcreteDecoratorB: Decorator {
    var component: Component?

    func setComponent(component: Component) {
        self.component = component
    }

    func operation() {
        if let component = self.component {
            component.operation()
        }
    }
}

/*Рассмотрим пример. Допустим, у нас есть пиццерия, которая готовит различные типы пицц с различными добавками. Есть итальянская, болгарская пиццы. К ним могут добавляться помидоры, сыр и т.д. И в зависимости от типа пицц и комбинаций добавок пицца может иметь разную стоимость. Теперь посмотрим, как это изобразить в программе на C#:*/

protocol Pizza {
    var name: String { get }
    func getCost() -> Int
}

class ItalianPizza: Pizza {
    var name: String

    init() {
        self.name = "Итальянская пицца"
    }

    func getCost() -> Int {
        return 10
    }
}

class BulgerianPizza: Pizza {
    var name: String

    init() {
        self.name = "Болгарская пицца"
    }

    func getCost() -> Int {
        return 15
    }
}

//ДЕКОРАТОРЫ ПИЦЦЫ
protocol PizzaDecorator: Pizza {
    var pizza: Pizza { get set }
    init(pizza: Pizza)
}


class TomatoPizza: PizzaDecorator {
    var pizza: Pizza
    var name: String

    required init(pizza: Pizza) {
        self.name = pizza.name + " с томатами"
        self.pizza = pizza
    }

    func getCost() -> Int {
        return self.pizza.getCost() + 3
    }
}

class CheesePizza: PizzaDecorator {
    var pizza: Pizza
    var name: String

    required init(pizza: Pizza) {
        self.name = pizza.name + " с сыром"
        self.pizza = pizza
    }

    func getCost() -> Int {
        return self.pizza.getCost() + 19
    }
}
