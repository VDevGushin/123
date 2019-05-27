//
//  Порождающие паттерны.swift
//  Patterns
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Порождающие паттерны
 // MARK: - Factory Method
 Factory Method (Фабричный метод) - определяет протокол(базовый класс, интерфейс) для создания объектов класса, но решение о том, объект какого класса нужно создать, происходит в подклассах.
 Базовый класс делегирует создание объекта классам наследникам.
 
 Когда можно применить паттерн:
 - Когда нам нужна независимая архитектура от процесса создания новых обхектов. Она должна быть расширяемой.
 - Когда мы заранее не знаем, объекты каких типов необходимо создать.
 - Когда нам нужно делегировать создание новых обхектов классам наследникам.
 
 Пример:
 ТЗ - мы занимаемся продажей авто. Вначале мы хотим заказать в наш автосалон машины марки kia. Для этого мы выбираем соотвествующий завод - производитель, который их производит (kia motors). Затем мы хотим реализовывать машины марки ford и для этого нам нужно будет выбрать соотвествущий завод.
 */

//Aбстрактный класс автомобильного завода
//определяет абстрактный фабричный метод create()
fileprivate protocol CarFactory {
    var name: String { get }
    init(name: String)
    func create() -> AutoCar
}

//AutoCar определяет интерфейс класса, объекты которого надо создавать.
fileprivate protocol AutoCar {
    var name: String { get }
}

//Конкретные классы KiaMotorsFactory и FordFactory - наследники класса CarFactory, определяющие свою реализацию метода create(). Причем метод create() каждого отдельного класса-создателя возвращает определенный конкретный тип продукта. Для каждого конкретного класса продукта определяется свой конкретный класс создателя.
fileprivate final class KiaMotorsCarFactory: CarFactory {
    var name: String

    init(name: String) {
        self.name = name
    }

    func create() -> AutoCar {
        return Kia()
    }
}

fileprivate final class FordCarFactory: CarFactory {
    var name: String

    init(name: String) {
        self.name = name
    }

    func create() -> AutoCar {
        return Ford()
    }
}

//Конкретные классы Kia и Ford представляют реализацию класса AutoCar.
//Таких классов может быть множество
fileprivate final class Kia: AutoCar {
    var name: String

    init() {
        self.name = "Kia"
    }
}


fileprivate final class Ford: AutoCar {
    var name: String

    init() {
        self.name = "Ford"
    }
}

fileprivate final class CarShowroom {
    var allCars: [AutoCar] = []

    func action() {
        //закупаем у завода kia автомобиль
        let kiaMotors = KiaMotorsCarFactory(name: "Завод Kia")
        let kiaCar = kiaMotors.create()

        //закупаем у завода ford автомобиль
        let fordMotors = FordCarFactory(name: "Завод Ford")
        let fordCar = fordMotors.create()

        //выставляем купленные автомобили в зал автосалона
        self.allCars.append(fordCar)
        self.allCars.append(kiaCar)
        dump(self.allCars)
    }
}
