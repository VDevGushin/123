//
//  Стратегия.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 22/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate protocol Strategy {
    func algorithm()
}

fileprivate class ConcreteStrategy1: Strategy {
    func algorithm() { }
}

fileprivate class ConcreteStrategy2: Strategy {
    func algorithm() { }
}

fileprivate class Context {
    let strategy: Strategy

    init(strategy: Strategy) {
        self.strategy = strategy
    }

    func executeAlgorithm() {
        self.strategy.algorithm()
    }
}

//=====================================================================================
fileprivate protocol Movable {
    func move()
}

//Бензиновый ход
fileprivate class PetrolMove: Movable {
    func move() {
        print("Бензиновый ход")
    }
}

//Электрический ход
fileprivate class ElectricMove: Movable {
    func move() {
        print("Электрический ход")
    }
}

//Машина
fileprivate class Car {
    private let passengers: Int
    private let model: String
    var movable: Movable

    init(passengers: Int, model: String, movable: Movable) {
        self.passengers = passengers
        self.model = model
        self.movable = movable
    }

    func move() {
        self.movable.move()
    }
}

fileprivate func main() {
    let auto = Car(passengers: 4, model: "Volvo", movable: PetrolMove())
    auto.move()
    auto.movable = ElectricMove()
    auto.move()
    print("car")
}
