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

// MARK: - Абстрактная фабрика
/*(Abstract Factory)— предоставляет интерфейс для создания семейств взаимосвязанных или взаимозависимых объектов, не специфицируя их конкретных классов.
 
 Шаблон реализуется созданием абстрактного класса(в нашем случае протокола) Factory, который представляет собой интерфейс для создания компонентов системы (например, для оконного интерфейса он может создавать окна и кнопки). Затем пишутся классы, реализующие этот интерфейс.

 Когда использовать абстрактную фабрику
 Когда система не должна зависеть от способа создания и компоновки новых объектов
 Когда создаваемые объекты должны использоваться вместе и являются взаимосвязанными
 
 Пример:
 ТЗ - Например, мы делаем игру, где пользователь должен управлять некими юнитами, при этом каждый юнит имеет определенное оружие и определенную модель передвижения. Различные юниты могут определяться комплексом признаков. Например, лучник может бегать и должен стрелять, другой супергерой должен ходить в тяжелых доспехах и управлять мечом. Таким образом, получается, что сущность оружия и модель передвижения являются взаимосвязанными и используются в комплексе. То есть имеется один из доводов в пользу использования абстрактной фабрики.*/
//Игра
func Game() {
    let archer = Unit(factory: ArcherFactory())
    archer.hit()
    archer.move()
    let swordsman = Unit(factory: SwordsmanFactory())
    swordsman.hit()
    swordsman.move()
}

// Юнит - основной гласс нашей боевой единицы в игре
class Unit {
    private let weapon: UnitWeapon
    private let movement: UnitMovement

    init(factory: UnitFactory) {
        self.weapon = factory.createWeapon()
        self.movement = factory.createMovement()
    }

    func move() {
        self.movement.move()
    }

    func hit() {
        self.weapon.hit()
    }
}

// Виды оружия в игре
protocol UnitWeapon {
    func hit()
}

class ArcherWeapon: UnitWeapon {
    func hit() {
        print("Стреляем")
    }
}

class SwordsmanWeapon: UnitWeapon {
    func hit() {
        print("Рубим")
    }
}

// Виды передвижения в игре
protocol UnitMovement {
    func move()
}

class ArcherMovement: UnitMovement {
    func move() {
        print("Бежим")
    }
}

class SwordsmanMovement: UnitMovement {
    func move() {
        print("Идем")
    }
}

// Абстрактная фабрика для создания взаимосвязанными объектов
protocol UnitFactory {
    func createMovement() -> UnitMovement
    func createWeapon() -> UnitWeapon
}

// Абстрактная фабрика для лучника
class ArcherFactory: UnitFactory {
    func createMovement() -> UnitMovement {
        return ArcherMovement()
    }

    func createWeapon() -> UnitWeapon {
        return ArcherWeapon()
    }
}

// Абстрактная фабрика для мечника
class SwordsmanFactory: UnitFactory {
    func createMovement() -> UnitMovement {
        return SwordsmanMovement()
    }

    func createWeapon() -> UnitWeapon {
        return SwordsmanWeapon()
    }
}
/*Таким образом, создание unit абстрагируется от самого класса unit. В то же время нельзя не отметить и недостатки шаблона. В частности, если нам захочется добавить в конфигурацию unit новый объект, например, тип одежды, то придется переделывать классы фабрик и класс супергероя. Поэтому возможности по расширению в данном паттерне имеют некоторые ограничения.*/
