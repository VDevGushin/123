//
//  Misc.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Swinject

fileprivate func test() {
    let container = Container()
    // MARK: - Value Types

    container.register(Animal.self) { _ in Turtle(name: "Ninja") }

    var turtle1 = container.resolve(Animal.self)!
    print(turtle1.name) // prints "Ninja"

    /*Поскольку turtle1 на самом деле является экземпляром структуры, хотя его тип выводится как протокол Animal, назначение его новому параметру создает новый экземпляр.*/

    var turtle2 = turtle1
    turtle2.name = "Samurai"
    print(turtle2.name) // prints "Samurai"
    print(turtle1.name) // prints "Ninja"


    // MARK: - Self-registration (Self-binding)
    /*В Swinject или других средах DI тип сервиса может быть не только протоколом, но также конкретным или абстрактным классом. Особый случай - когда тип сервиса и тип компонента идентичны. Этот случай называется саморегистрацией или самообязанием. Вот пример самосвязывания с Swinject:*/
    container.register(Animal.self) { _ in Cat(name: "Mimi") }
    
    //PetOwner - название класса а не протокола
    container.register(PetOwner.self) { r in
        PetOwner(name: "Selfie", pet: r.resolve(Animal.self)!)
    }
    
    let owner = container.resolve(PetOwner.self)!
    print(owner.name) // prints "Selfie"
    print(owner.pet.name) // prints "Mimi"
}

fileprivate protocol Animal {
    var name: String { get set }
}

fileprivate protocol Person {
    var name: String { get }
}

fileprivate struct Turtle: Animal {
    var name: String
}

fileprivate struct Cat: Animal {
    var name: String
}

fileprivate class PetOwner: Person {
    let name: String
    let pet: Animal

    init(name: String, pet: Animal) {
        self.name = name
        self.pet = pet
    }
}
