//
//  Абстрактная фабрика.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 16/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

//Fabric
fileprivate protocol AbstractFactory {
    func createProductA() -> ProductA
    func createProductB() -> ProductB
}

fileprivate class ConcreteFactory1: AbstractFactory {
    func createProductA() -> ProductA {
        return ConcreteAProduct1()
    }

    func createProductB() -> ProductB {
        return ConcreteBProduct1()
    }
}

fileprivate class ConcreteFactory2: AbstractFactory {
    func createProductA() -> ProductA {
        return ConcreteAProduct2()
    }

    func createProductB() -> ProductB {
        return ConcreteBProduct2()
    }
}
//////////////
//Products
fileprivate protocol ProductA { }
fileprivate protocol ProductB { }

fileprivate class ConcreteAProduct1: ProductA { }
fileprivate class ConcreteAProduct2: ProductA { }

fileprivate class ConcreteBProduct1: ProductB { }
fileprivate class ConcreteBProduct2: ProductB { }
//////////////
//Client
fileprivate class FabricTestClient {
    private var porduct1: ProductA?
    private var porduct2: ProductB?

    init(factory: AbstractFactory) {
        self.porduct1 = factory.createProductA()
        self.porduct2 = factory.createProductB()
    }
}
//////////////
/*Посмотрим, как мы можем применить паттерн. Например, мы делаем игру, где пользователь должен управлять некими супергероями, при этом каждый супергерой имеет определенное оружие и определенную модель передвижения. Различные супергерои могут определяться комплексом признаков. Например, эльф может летать и должен стрелять из арбалета, другой супергерой должен бегать и управлять мечом. Таким образом, получается, что сущность оружия и модель передвижения являются взаимосвязанными и используются в комплексе. То есть имеется один из доводов в пользу использования абстрактной фабрики.
 
 И кроме того, наша задача при проектировании игры абстрагировать создание супергероев от самого класса супергероя, чтобы создать более гибкую архитектуру. И для этого применим абстрактную фабрику:
*/

//// клиент - сам супергерой
class Hero {
    private let weapon: Weapon
    private let movement: Movement

    init(factory: HeroFactory) {
        self.weapon = factory.createWeapon()
        self.movement = factory.createMovement()
    }

    func run() {
        self.movement.move()
    }

    func hit() {
        self.weapon.hit()
    }
}

//Weapon
protocol Weapon {
    func hit()
}

class Arbalet: Weapon {
    func hit() {
        print("Стреляем из арбалета")
    }
}

class Sword: Weapon {
    func hit() {
        print("Рубим мечом")
    }
}
////////////////////////////////////////////
//Movement
protocol Movement {
    func move()
}

class FlyMovement: Movement {
    func move() {
        print("Летим")
    }
}

class RunMovement: Movement {
    func move() {
        print("Бежим")
    }
}
////////////////////////////////////////////
//HeroFactory - фабрика для создания героев - все компоненты фабрики должны использоваться вметсве и быть взаимосвязанными
protocol HeroFactory {
    func createMovement() -> Movement
    func createWeapon() -> Weapon
}

class ElfFactory: HeroFactory {
    func createMovement() -> Movement {
        return FlyMovement()
    }

    func createWeapon() -> Weapon {
        return Arbalet()
    }
}

class VoinFactory: HeroFactory {
    func createMovement() -> Movement {
        return RunMovement()
    }

    func createWeapon() -> Weapon {
        return Sword()
    }
}
