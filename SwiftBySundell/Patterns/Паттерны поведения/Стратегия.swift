//
//  Стратегия.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 22/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Паттерн Стратегия (Strategy) представляет шаблон проектирования, который определяет набор алгоритмов, инкапсулирует каждый из них и обеспечивает их взаимозаменяемость. В зависимости от ситуации мы можем легко заменить один используемый алгоритм другим. При этом замена алгоритма происходит независимо от объекта, который использует данный алгоритм.
 
 Когда использовать стратегию?
 
 Когда есть несколько родственных классов, которые отличаются поведением. Можно задать один основной класс, а разные варианты поведения вынести в отдельные классы и при необходимости их применять
 
 Когда необходимо обеспечить выбор из нескольких вариантов алгоритмов, которые можно легко менять в зависимости от условий
 
 Когда необходимо менять поведение объектов на стадии выполнения программы
 
 Когда класс, применяющий определенную функциональность, ничего не должен знать о ее реализации
 */

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
