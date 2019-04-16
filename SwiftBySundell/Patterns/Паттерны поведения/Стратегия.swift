//
//  Стратегия.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 16/04/2019.
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

fileprivate class Client {
    private let strategy: Strategy

    init(strategy: Strategy) {
        self.strategy = strategy
        //run algorithm
        self.strategy.algorithm()
    }
}

/*Теперь рассмотрим конкретный пример. Существуют различные легковые машины, которые используют разные источники энергии: электричество, бензин, газ и так далее. Есть гибридные автомобили. В целом они похожи и отличаются преимущественно видом источника энергии. Не говоря уже о том, что мы можем изменить применяемый источник энергии, модифицировав автомобиль. И в данном случае вполне можно применить паттерн стратегию:*/
fileprivate protocol Movable {
    func move()
}

fileprivate class PetrolMove: Movable {
    func move() {
        print("Перемещение на бензине")
    }
}

fileprivate class ElectricMove: Movable {
    func move() {
        print("Перемещение на электричестве")
    }
}

fileprivate class Car {
    private let passengers: Int
    private let model: String
    var movable: Movable

    init(num: Int, model: String, mov: Movable) {
        self.passengers = num
        self.model = model
        self.movable = mov
    }

    func move() {
        self.movable.move()
    }
}

fileprivate func main() {
    let auto = Car(num: 4, model: "Volvo", mov: PetrolMove())
    auto.move()
    //в нужных местах мы можем менять поведение класса
    auto.movable = ElectricMove()
    auto.move()
}
