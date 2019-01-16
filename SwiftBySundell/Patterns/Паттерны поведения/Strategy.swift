//
//  Strategy.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 16/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Паттерн Стратегия (Strategy) представляет шаблон проектирования, который определяет набор алгоритмов, инкапсулирует каждый из них и обеспечивает их взаимозаменяемость. В зависимости от ситуации мы можем легко заменить один используемый алгоритм другим. При этом замена алгоритма происходит независимо от объекта, который использует данный алгоритм.
 */
/*
 Когда использовать стратегию?
    1)Когда есть несколько родственных классов, которые отличаются поведением. Можно задать один основной класс, а разные варианты поведения вынести в отдельные классы и при необходимости их применять
 
    2)Когда необходимо обеспечить выбор из нескольких вариантов алгоритмов, которые можно легко менять в зависимости от условий
 
    3)Когда необходимо менять поведение объектов на стадии выполнения программы
 
    4)Когда класс, применяющий определенную функциональность, ничего не должен знать о ее реализации
 */

//Формальный вид

//Интерфейс IStrategy, который определяет метод Algorithm(). Это общий интерфейс для всех реализующих его алгоритмов. Вместо интерфейса здесь также можно было бы использовать абстрактный класс.
fileprivate protocol Strategy {
    func algorithm()
}

//Классы ConcreteStrategy1 и ConcreteStrategy, которые реализуют интерфейс IStrategy, предоставляя свою версию метода Algorithm(). Подобных классов-реализаций может быть множество.
fileprivate class ConcreteStrategy1: Strategy {
    func algorithm() { }
}

fileprivate class ConcreteStrategy2: Strategy {
    func algorithm() { }
}

//Класс Context хранит ссылку на объект IStrategy и связан с интерфейсом IStrategy отношением агрегации.
fileprivate class Context {
    private var strategy: Strategy

    init(strategy: Strategy) {
        self.strategy = strategy
    }

    func executeAlgorithm() {
        self.strategy.algorithm()
    }
}

/*Теперь рассмотрим конкретный пример. Существуют различные легковые машины, которые используют разные источники энергии: электричество, бензин, газ и так далее. Есть гибридные автомобили. В целом они похожи и отличаются преимущественно видом источника энергии. Не говоря уже о том, что мы можем изменить применяемый источник энергии, модифицировав автомобиль. И в данном случае вполне можно применить паттерн стратегию:*/

fileprivate protocol Movable {
    func move()
}

fileprivate class PetrolMove: Movable {
    func move() {
        print ("Перемещение на бензине")
    }
}

fileprivate class ElectricMove: Movable {
    func move() {
        print ("Перемещение на электричестве")
    }
}

fileprivate class Car {
    private let passengers: Int
    private let model: String
    var movable: Movable// можно менять способ передвижения

    init(passengers: Int, model: String, movable: Movable) {
        self.passengers = passengers
        self.model = model
        self.movable = movable
    }

    func move() {
        self.movable.move()
    }
}

fileprivate class Program {
    fileprivate func main() {
        let auto = Car(passengers: 4, model: "Volvo", movable: PetrolMove())
        auto.move()
        auto.movable = ElectricMove()
        auto.move()
    }
}
