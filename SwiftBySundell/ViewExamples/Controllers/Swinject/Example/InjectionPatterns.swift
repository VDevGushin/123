//
//  InjectionPatterns.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Swinject

// MARK: - Initializer Injection
fileprivate func registerContainer() {
    let container = Container()

    container.register(Animal.self) { _ in Cat() }

    container.register(Person.self) { r in
        PetOwner(pet: r.resolve(Animal.self)!)
    }

    container.register(Person.self) { _, animal in
        PetOwner(pet: animal)
    }
}

// MARK: - Property Injection
fileprivate func propertyInjection() {
    let container = Container()
    container.register(Animal.self) { _ in Cat() }
    //Можно инициализировать проперти класса без конструктора
    container.register(Person.self) { r in
        let owner = PetOwner2()
        owner.pet = r.resolve(Animal.self)
        return owner
    }

    //Or, you can use initCompleted callback instead of defining the injection in the registration closure:
    container.register(Person.self) { _ in PetOwner2() }
        .initCompleted { r, p in
            let owner = p as! PetOwner2
            owner.pet = r.resolve(Animal.self)
    }
}

// MARK: - Method Injection
fileprivate func methodInjection() {
    let container = Container()
    container.register(Animal.self) { _ in Cat() }

    container.register(Person.self) { r in
        let owner = PetOwner3()
        owner.setPet(pet: r.resolve(Animal.self)!)
        return owner
    }
}


/////////////////////////////////////////////////////////
fileprivate protocol Animal {
    func sound() -> String
}

fileprivate class Cat: Animal {
    init() { }

    func sound() -> String {
        return "Meow"
    }
}

fileprivate protocol Person { }

fileprivate class PetOwner: Person {
    let pet: Animal

    init(pet: Animal) {
        self.pet = pet
    }
}

fileprivate class PetOwner2: Person {
    var pet: Animal?

    init() { }
}

fileprivate class PetOwner3: Person {
    var pet: Animal?

    init() { }

    func setPet(pet: Animal) {
        self.pet = pet
    }
}
