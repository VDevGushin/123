//
//  Decorator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 07/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Декоратор (Decorator) представляет структурный шаблон проектирования, который позволяет динамически подключать к объекту дополнительную функциональность.
 
 Для определения нового функционала в классах нередко используется наследование. Декораторы же предоставляет наследованию более гибкую альтернативу, поскольку позволяют динамически в процессе выполнения определять новые возможности у объектов.
 
 Когда следует использовать декораторы?
 
    1)Когда надо динамически добавлять к объекту новые функциональные возможности. При этом данные возможности могут быть сняты с объекта
 
    2)Когда применение наследования неприемлемо. Например, если нам надо определить множество различных функциональностей и для каждой функциональности наследовать отдельный класс, то структура классов может очень сильно разрастись. Еще больше она может разрастись, если нам необходимо создать классы, реализующие все возможные сочетания добавляемых функциональностей.
 */
//Формальная организация:
//Aбстрактный класс, который определяет интерфейс для наследуемых объектов
fileprivate protocol Component {
    func operation()
}

//Конкретная реализация компонента, в которую с помощью декоратора добавляется новая функциональность
fileprivate class ConcreteComponent: Component {
    func operation() { }
}

/*Cобственно декоратор, реализуется в виде абстрактного класса и имеет тот же базовый класс, что и декорируемые объекты. Поэтому базовый класс Component должен быть по возможности легким и определять только базовый интерфейс.
 Класс декоратора также хранит ссылку на декорируемый объект в виде объекта базового класса Component и реализует связь с базовым классом как через наследование, так и через отношение агрегации.*/
fileprivate protocol Decorator: class, Component {
    var component: Component? { get set }
    func setComponent(component: Component)
    func operation()
}

fileprivate extension Decorator {
    func setComponent(component: Component) {
        self.component = component
    }

    func operation() {
        self.component?.operation()
    }
}

fileprivate class ConcreteDecoratorA: Decorator {
    var component: Component?

    //расширяем возможности
    func newFunc() {
        //новая логика, которая работает совместно с компонентом
    }
}

fileprivate class ConcreteDecoratorB: Decorator {
    var component: Component?

    //расширяем возможности
    func newFunc() {
        //новая логика, которая работает совместно с компонентом
    }
}

/*Рассмотрим пример. Допустим, у нас есть пиццерия, которая готовит различные типы пицц с различными добавками. Есть итальянская, болгарская пиццы. К ним могут добавляться помидоры, сыр и т.д. И в зависимости от типа пицц и комбинаций добавок пицца может иметь разную стоимость. Теперь посмотрим, как это изобразить в программе на C#:*/

fileprivate protocol Pizza: class {
    var name: String { get set }
    func getCost() -> Int
    init(name: String)
}

fileprivate class ItalianPizza: Pizza {
    var name: String

    func getCost() -> Int {
        return 10
    }

    required init(name: String = "Итальянская пицца") {
        self.name = name
    }
}

fileprivate class BulgerianPizza: Pizza {
    var name: String

    func getCost() -> Int {
        return 10
    }

    required init(name: String = "Болгарская пицца") {
        self.name = name
    }
}

fileprivate protocol PizzaDecorator: Pizza {
    var pizza: Pizza? { get set }
    init(pizza: Pizza)
}

fileprivate class TomatoPizza: PizzaDecorator {
    var pizza: Pizza?
    var name: String

    required convenience init(pizza: Pizza) {
        self.init(name: pizza.name)
        self.pizza = pizza
    }

    func getCost() -> Int {
        return self.pizza?.getCost() ?? 0 + 3
    }

    required init(name: String) {
        self.pizza = nil
        self.name = "\(name), с томатами"
    }
}

fileprivate class CheesePizza: PizzaDecorator {
    var pizza: Pizza?
    var name: String

    required convenience init(pizza: Pizza) {
        self.init(name: pizza.name)
        self.pizza = pizza
    }

    func getCost() -> Int {
        return self.pizza?.getCost() ?? 0 + 5
    }

    required init(name: String) {
        self.pizza = nil
        self.name = "\(name), с сыром"
    }
}

fileprivate class Program {
    func main() {
        let pizzaItalian = ItalianPizza()
        let tomatoPizza1 = TomatoPizza(pizza: pizzaItalian)

        let pizza2 = ItalianPizza()
        let tomatoPizza2 = CheesePizza(pizza: pizza2)
        dump(tomatoPizza1)
        dump(tomatoPizza2)
    }
}
