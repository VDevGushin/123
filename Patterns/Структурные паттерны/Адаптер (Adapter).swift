//
//  Адаптер (Adapter).swift
//  Patterns
//
//  Created by Vlad Gushchin on 16/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Паттерн Адаптер (Adapter) предназначен для преобразования интерфейса одного класса в интерфейс другого.
Благодаря реализации данного паттерна мы можем использовать вместе классы с несовместимыми интерфейсами.
 
Когда надо использовать Адаптер?
Когда необходимо использовать имеющийся класс, но его интерфейс не соответствует потребностям
Когда надо использовать уже существующий класс совместно с другими классами, интерфейсы которых не совместимы*/

fileprivate class Client {
    func request(target: Target) {
        target.request()
    }
}

// Базовый класс, для которого нужен адаптер
fileprivate class Target {
    func request() { }
}

// Адаптер
fileprivate class Adapter: Target {
    private let adaptee = Adaptee()
    override func request() {
        self.adaptee.specificRequest()
    }
}

fileprivate class Adaptee {
    func specificRequest() { }
}

/*Теперь разберем реальный пример. Допустим, у нас есть путешественник, который путешествует на машине. Но в какой-то момент ему приходится передвигаться по пескам пустыни, где он не может ехать на машине. Зато он может использовать для передвижения верблюда. Однако в классе путешественника использование класса верблюда не предусмотрено, поэтому нам надо использовать адаптер:*/

protocol Transport {
    func drive()
}

// класс машины
struct Auto: Transport {
    func drive() {
        print("Машина едет по дороге")
    }
}

struct Driver {
    func travel(with transport: Transport) {
        transport.drive()
    }
}

protocol Animal {
    func move()
}

struct Camel: Animal {
    func move() {
        print("Верблюд идет по пустыни")
    }
}

// Адаптер от Camel к ITransport
struct AnimalToTransportAdapter: Transport {
    let animal: Animal
    init(animal: Animal) {
        self.animal = animal
    }

    func drive() {
        self.animal.move()
    }
}

func adapterTravelSimulation() {
    let driver = Driver()
    let auto = Auto()
    driver.travel(with: auto)

    //Встретились пески - нужно пересаживаться на верблюда
    let camel = Camel()
    //Испльзуем адаптер
    driver.travel(with: AnimalToTransportAdapter(animal: camel))
}
