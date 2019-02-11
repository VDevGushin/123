//
//  Adapter.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Паттерн Адаптер (Adapter) предназначен для преобразования интерфейса одного класса в интерфейс другого. Благодаря реализации данного паттерна мы можем использовать вместе классы с несовместимыми интерфейсами.
 
 Когда надо использовать Адаптер?
 
    1)Когда необходимо использовать имеющийся класс, но его интерфейс не соответствует потребностям
 
    2)Когда надо использовать уже существующий класс совместно с другими классами, интерфейсы которых не совместимы
 
 Формальное определение паттерна на UML выглядит следующим образом:*/

//Client: использует объекты Target для реализации своих задач
fileprivate class Client {
    func request(target: Target) {
        target.request()
    }
}

//Target: представляет объекты, которые используются клиентом
fileprivate class Target {
    func request() { }
}

//представляет адаптируемый класс, который мы хотели бы использовать у клиента вместо объектов Target
fileprivate class Adaptee {
    func specificRequest() { }
}

fileprivate class Adapter: Target {
    private let adaptee: Adaptee
    init(adaptee: Adaptee) {
        self.adaptee = adaptee
    }

    override func request() {
        adaptee.specificRequest()
    }
}

/*То есть клиент ничего не знает об Adaptee, он знает и использует только объекты Target. И благодаря адаптеру мы можем на клиенте использовать объекты Adaptee как Target
 
 Теперь разберем реальный пример. Допустим, у нас есть путешественник, который путешествует на машине. Но в какой-то момент ему приходится передвигаться по пескам пустыни, где он не может ехать на машине. Зато он может использовать для передвижения верблюда. Однако в классе путешественника использование класса верблюда не предусмотрено, поэтому нам надо использовать адаптер:*/


fileprivate protocol Transport {
    func drive()
}

fileprivate class Auto: Transport {
    func drive() {
        print("Машина едет по дороге")
    }
}

fileprivate class Driver {
    func travel(with transport: Transport) {
        transport.drive()
    }
}

fileprivate protocol Animal {
    func move()
}

fileprivate class Camel: Animal {
    func move() {
        print("Верблюд идет по пустыни")
    }
}

fileprivate class AnimalAdapterForTransport: Transport {
    let animal: Animal

    fileprivate init(animal: Animal) {
        self.animal = animal
    }

    func drive() {
        self.animal.move()
    }
}

fileprivate class Program {
    func main() {
        let driver = Driver()
        let auto = Auto()
        driver.travel(with: auto)

        let camel = Camel()
        driver.travel(with: AnimalAdapterForTransport(animal: camel))
    }
}
