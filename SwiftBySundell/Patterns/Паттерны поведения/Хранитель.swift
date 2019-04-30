//
//  Хранитель.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 30/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Паттерн Хранитель (Memento) позволяет выносить внутреннее состояние объекта за его пределы для последующего возможного восстановления объекта без нарушения принципа инкапсуляции.
 
 Когда использовать Memento?
 
 Когда нужно сохранить состояние объекта для возможного последующего восстановления

 Когда сохранение состояния должно проходить без нарушения принципа инкапсуляции
*/

/*Memento: хранитель, который сохраняет состояние объекта Originator и предоставляет полный доступ только этому объекту Originator
 Originator: создает объект хранителя для сохранения своего состояния
 Caretaker: выполняет только функцию хранения объекта Memento, в то же время у него нет полного доступа к хранителю и никаких других операций над хранителем, кроме собственно сохранения, он не производит*/

fileprivate class Memento {
    let state: String
    init(state: String) {
        self.state = state
    }
}

fileprivate class Caretaker {
    let memento: Memento
    init(memento: Memento) {
        self.memento = memento
    }
}

fileprivate class Originator {
    private var state: String

    init(state: String) {
        self.state = state
    }

    func setMemento(memento: Memento) {
        self.state = memento.state
    }

    func createMemento() -> Memento {
        return Memento(state: self.state)
    }
}

//Теперь рассмотрим реальный пример: нам надо сохранять состояние игрового персонажа в игре:

// Memento
fileprivate struct HeroMemento: Hashable, Equatable {
    let patrons: Int
    let lives: Int
}

// Originator
fileprivate class Hero {
    private var patrons: Int = 10
    private var lives: Int = 5

    func shoot() {
        if self.patrons > 0 {
            self.patrons -= 1
            print("Производим выстрелы. Осталось \(patrons) патронов")
        } else {
            print("Патронов больше нет")
        }
    }

    func saveState() -> HeroMemento {
        print("Сохранение игры")
        return HeroMemento(patrons: self.patrons, lives: self.lives)
    }

    func restoreState(memento: HeroMemento) {
        print("Востановление игры")
        self.patrons = memento.patrons
        self.lives = memento.lives
    }
}

// Caretaker
fileprivate class GameHistory {
    var history: Set<HeroMemento>
    init() {
        self.history = Set()
    }
}

fileprivate func main() {
    let hero = Hero()
    hero.shoot()// делаем выстрел, осталось 9 патронов

    let game = GameHistory()
    game.history.insert(hero.saveState())// сохраняем игру

    hero.shoot()//делаем выстрел, осталось 8 патронов

    hero.restoreState(memento: Array(game.history).last!)

    hero.shoot()//делаем выстрел, осталось 8 патронов

}
