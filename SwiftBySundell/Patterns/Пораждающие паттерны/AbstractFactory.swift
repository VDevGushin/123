//
//  AbstractFactory.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*
 Паттерн "Абстрактная фабрика" (Abstract Factory) предоставляет интерфейс
 для создания семейств взаимосвязанных объектов с определенными интерфейсами без указания конкретных типов данных объектов.
 
 Когда использовать абстрактную фабрику:
    1)Когда система не должна зависеть от способа создания и компоновки новых объектов
    2)Когда создаваемые объекты должны использоваться вместе и являются взаимосвязанными!
 */

//Абстрактные классы AbstractProductA и AbstractProductB определяют интерфейс для классов, объекты которых будут создаваться в программе.
fileprivate protocol AbstractProductA { }
fileprivate protocol AbstractProductB { }

//Конкретные классы ProductA1 / ProductA2 и ProductB1 / ProductB2 представляют конкретную реализацию абстрактных классов
class ProductA1: AbstractProductA { }
class ProductA2: AbstractProductA { }

class ProductB1: AbstractProductB { }
class ProductB2: AbstractProductB { }

//Абстрактный класс фабрики AbstractFactory определяет методы для создания объектов. Причем методы возвращают абстрактные продукты, а не их конкретные реализации.
fileprivate protocol AbstractFactory {
    func createProductA() -> AbstractProductA
    func createProductB() -> AbstractProductB
}

//Конкретные классы фабрик ConcreteFactory1 и ConcreteFactory2 реализуют абстрактные методы базового класса и непосредственно определяют какие конкретные продукты использовать
fileprivate class ConcreteFactory1: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ProductA1()
    }

    func createProductB() -> AbstractProductB {
        return ProductB1()
    }
}

fileprivate class ConcreteFactory2: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ProductA2()
    }

    func createProductB() -> AbstractProductB {
        return ProductB2()
    }
}

//Класс клиента Client использует класс фабрики для создания объектов. При этом он использует исключительно абстрактный класс фабрики AbstractFactory и абстрактные классы продуктов AbstractProductA и AbstractProductB и никак не зависит от их конкретных реализаций
fileprivate class Client {
    private let abstractProductA: AbstractProductA
    private let abstractProductB: AbstractProductB

    init(factory: AbstractFactory) {
        self.abstractProductA = factory.createProductA()
        self.abstractProductB = factory.createProductB()
    }
}
//============================================================================================================================================================================================================================================================================================================

/*Посмотрим, как мы можем применить паттерн. Например, мы делаем игру, где пользователь должен управлять некими супергероями, при этом каждый супергерой имеет определенное оружие и определенную модель передвижения. Различные супергерои могут определяться комплексом признаков. Например, эльф может летать и должен стрелять из арбалета, другой супергерой должен бегать и управлять мечом. Таким образом, получается, что сущность оружия и модель передвижения являются взаимосвязанными и используются в комплексе. То есть имеется один из доводов в пользу использования абстрактной фабрики.
 
 И кроме того, наша задача при проектировании игры абстрагировать создание супергероев от самого класса супергероя, чтобы создать более гибкую архитектуру. И для этого применим абстрактную фабрику:
 */

//абстрактный класс - оружие
fileprivate protocol Weapon {
    func hit()
}

//абстрактный класс движение
fileprivate protocol Movement {
    func move()
}

// класс арбалет
fileprivate class Arbalet: Weapon {
    func hit() {
        print("Стреляем из арбалета")
    }
}

// класс меч
fileprivate class Sword: Weapon {
    func hit() {
        print("Бьем мечем")
    }
}

// движение полета
fileprivate class FlyMovement: Movement {
    func move() {
        print("Летим")
    }
}

// движение бег
fileprivate class RunMovement: Movement {
    func move() {
        print("Бежим")
    }
}

// класс абстрактной фабрики
fileprivate protocol HeroFactory {
    func createMovement() -> Movement
    func createWeapon() -> Weapon
}

// Фабрика создания летящего героя с арбалетом
fileprivate class ElfFactory: HeroFactory {
    func createMovement() -> Movement {
        return RunMovement()
    }

    func createWeapon() -> Weapon {
        return Arbalet()
    }
}

// Фабрика создания бегущего героя с мечом
fileprivate class WarriorFactory: HeroFactory {
    func createMovement() -> Movement {
        return RunMovement()
    }

    func createWeapon() -> Weapon {
        return Sword()
    }
}

// клиент - сам супергерой

fileprivate class Hero {
    private let weapon: Weapon
    private let movement: Movement

    init(factory: HeroFactory) {
        self.weapon = factory.createWeapon()
        self.movement = factory.createMovement()
    }

    func run() {
        movement.move()
    }

    func hit() {
        weapon.hit()
    }
}
/*
 Таким образом, создание супергероя абстрагируется от самого класса супергероя. В то же время нельзя не отметить и недостатки шаблона. В частности, если нам захочется добавить в конфигурацию супергероя новый объект, например, тип одежды, то придется переделывать классы фабрик и класс супергероя. Поэтому возможности по расширению в данном паттерне имеют некоторые ограничения.
 */
fileprivate func TEST() {
    let elf = Hero(factory: ElfFactory())
    let orc = Hero(factory: WarriorFactory())
    dump(elf)
    dump(orc)
}
