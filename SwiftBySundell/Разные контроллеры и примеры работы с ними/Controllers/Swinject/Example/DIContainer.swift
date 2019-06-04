//
//  DIContainer.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Swinject

// MARK: - Work with containter
final class AppContainer {
    let container = Container()
    // MARK: - Registration in a DI Container
    //Обычная регистрация
    func register() {
        self.container.register(Animal.self) { _ in
            Cat(name: "Mimi")
        }

        self.container.register(Person.self) { resolver in
            PetOwner(name: "Stephen", pet: resolver.resolve(Animal.self)!)
        }
    }

    //Работа с данными из контейнера
    func resolveData() {
        let animal = self.container.resolve(Animal.self)!
        let person = self.container.resolve(Person.self)!
        let pet = (person as! PetOwner).pet

        print(animal.name) // prints "Mimi"
        print(animal is Cat) // prints "true"
        print(person.name) // prints "Stephen"
        print(person is PetOwner) // prints "true"
        print(pet.name) // prints "Mimi"
        print(pet is Cat) // prints "true"
    }

    // MARK: - Named Registration in a DI Container
    //Регистарция по имени
    func nameRegistration() {
        self.container.register(Animal.self, name: "cat") { _ in
            Cat(name: "Mimi")
        }

        self.container.register(Animal.self, name: "dog") { _ in
            Dog(name: "Hachi")
        }
    }

    //Работа с данными из контейнера по имени
    func resolveDataByName() {
        let cat = self.container.resolve(Animal.self, name: "cat")!
        let dog = self.container.resolve(Animal.self, name: "dog")!

        print(cat.name) // prints "Mimi"
        print(cat is Cat) // prints "true"
        print(dog.name) // prints "Hachi"
        print(dog is Dog) // prints "true"
    }

    // MARK: - Registration with Arguments in a DI Container
    func argumentRegistration() {
        self.container.register(Animal.self) { _, name in
            Horse(name: name)
        }

        self.container.register(Animal.self) { _, name, running in
            Horse(name: name, running: running)
        }
    }

    func resolveDataWithArgument() {
        let animal1 = container.resolve(Animal.self, argument: "Spirit")!
        print(animal1.name) // prints "Spirit"
        print((animal1 as! Horse).running) // prints "false"

        let animal2 = container.resolve(Animal.self, arguments: "Lucky", true)!
        print(animal2.name) // prints "Lucky"
        print((animal2 as! Horse).running) // prints "true"
    }

    // MARK: - Registration with Arguments in a DI Container
    func test() {
        //Например, следующие регистрации могут сосуществовать в контейнере, потому что типы служб различаются:
        self.container.register(Animal.self) { _ in Cat(name: "Mimi") }
        self.container.register(Person.self) { r in
            PetOwner(name: "Stephen", pet: r.resolve(Animal.self)!)
        }
        //Следующие регистрации могут сосуществовать в контейнере, потому что регистрационные имена разные:
        self.container.register(Animal.self, name: "cat") { _ in Cat(name: "Mimi") }
        self.container.register(Animal.self, name: "dog") { _ in Dog(name: "Hachi") }

        //Следующие регистрации могут сосуществовать в контейнере, потому что количество аргументов отличается. Первая регистрация не имеет аргументов, а вторая имеет аргумент:

        self.container.register(Animal.self) { _ in Cat(name: "Mimi") }
        self.container.register(Animal.self) { _, name in Cat(name: name) }
        //Следующие регистрации могут сосуществовать в контейнере, потому что типы аргументов различны. Первая регистрация имеет типы String и Bool. Вторая регистрация имеет типы Bool и String в следующем порядке:
        self.container.register(Animal.self) { _, name, running in
            Horse(name: name, running: running)
        }
        self.container.register(Animal.self) { _, running, name in
            Horse(name: name, running: running)
        }
    }

    // MARK: - Remark
    func remark() {
        container.register(Animal.self) { _, name in Cat(name: name) }
        // This is the correct Registration Key (Animal, (String) -> Animal)
        let name1: String = "Mimi"
        let mimi1 = container.resolve(Animal.self, argument: name1) // Returns a Cat instance.
        
        // Cannot resolve since the container has no Registration Key matching (Animal, (NSString) -> Animal)
        let name2: NSString = "Mimi"
        let mimi2 = container.resolve(Animal.self, argument: name2) // Returns nil.
        
        // Cannot resolve since the container has no Registration Key matching (Animal, (Optional<String>) -> Animal)
        let name3: String? = "Mimi"
        let mimi3 = container.resolve(Animal.self, argument: name3) // Returns nil.
        
        // Cannot resolve since the container has no Registration Key matching (Animal, (ImplicitlyUnwrappedOptional<String>) -> Animal)
        let name4: String! = "Mimi"
        let mimi4 = container.resolve(Animal.self, argument: name4) // Returns nil.
    }
}


// MARK: - help classes
fileprivate protocol Animal {
    var name: String { get }
}
fileprivate protocol Person {
    var name: String { get }
}

fileprivate class Cat: Animal {
    let name: String

    init(name: String) {
        self.name = name
    }
}

fileprivate class Dog: Animal {
    let name: String

    init(name: String) {
        self.name = name
    }
}

fileprivate class PetOwner: Person {
    let name: String
    let pet: Animal

    init(name: String, pet: Animal) {
        self.name = name
        self.pet = pet
    }
}

fileprivate class Horse: Animal {
    let name: String
    let running: Bool

    convenience init(name: String) {
        self.init(name: name, running: false)
    }

    init(name: String, running: Bool) {
        self.name = name
        self.running = running
    }
}
