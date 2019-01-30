//
//  Memento.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 30/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*
 Паттерн Хранитель (Memento) позволяет выносить внутреннее состояние объекта за его пределы для последующего возможного восстановления объекта без нарушения принципа инкапсуляции.
 
 Когда использовать Memento?
 
 Когда нужно сохранить состояние объекта для возможного последующего восстановления
 
 Когда сохранение состояния должно проходить без нарушения принципа инкапсуляции
 
 То есть ключевыми понятиями для данного паттерна являются сохранение внутреннего состояния и инкапсуляция, и важно соблюсти баланс между ними. Ведь, как правило, если мы не нарушаем инкапсуляцию, то состояние объекта хранится в объекте в приватных переменных. И не всегда для доступа к этим переменным есть методы или свойства с сеттерами и геттерами. Например, в игре происходит управление героем, все состояние которого заключено в нем самом - оружие героя, показатель жизней, силы, какие-то другие показатели. И нередко может возникнуть ситуация, сохранить все эти показатели во вне, чтобы в будущем можно было откатиться к предыдущему уровню и начать игру заново. В этом случае как раз и может помочь паттерн Хранитель.
 */

//Memento: хранитель, который сохраняет состояние объекта Originator и предоставляет полный доступ только этому объекту Originator
fileprivate class Memento {
    let state: String
    init(state: String) {
        self.state = state
    }
}

//Caretaker: выполняет только функцию хранения объекта Memento, в то же время у него нет полного доступа к хранителю и никаких других операций над хранителем, кроме собственно сохранения, он не производит
fileprivate class Caretaker {
    let memento: Memento
    init(memento: Memento) {
        self.memento = memento
    }
}

//Originator: создает объект хранителя для сохранения своего состояния
fileprivate class Originator {
    let state: String
    init(memento: Memento) {
        self.state = memento.state
    }

    func createMemento() -> Memento {
        return Memento(state: state)
    }
}

//Теперь рассмотрим реальный пример: нам надо сохранять состояние игрового персонажа в игре:
fileprivate class Hero {
    private var patrons: Int = 10 // кол-во патронов
    private var lives: Int = 5 // кол-во жизней

    func shoot() {
        if patrons > 0 {
            patrons -= 1
            print("Производим выстрел. Осталось \(patrons) патронов")
        } else {
            print("Патронов больше нет")
        }
    }

    // сохранение состояния
    func saveState() -> HeroMemento {
        print("Сохранение игры. Параметры: \(patrons) патронов, \(lives) жизней")
        return HeroMemento(patrons: patrons, lives: lives)
    }


    // восстановление состояния
    func restoreState(memento: HeroMemento) {
        self.patrons = memento.patrons
        self.lives = memento.lives
        print("Востановление игры. Параметры: \(patrons) патронов, \(lives) жизней")
    }

}

fileprivate struct HeroMemento: Hashable {
    let patrons: Int
    let lives: Int
}

// Caretaker
fileprivate class GameHistory {
    var history = [HeroMemento]()
}

fileprivate class Programm {
    func main() {
        let hero = Hero()
        hero.shoot()// делаем выстрел, осталось 9 патронов
        let game = GameHistory()
        game.history.append(hero.saveState())// сохраняем игру
        hero.shoot()//делаем выстрел, осталось 8 патронов
        if let lastSave = game.history.last {
            hero.restoreState(memento: lastSave)
        }
        hero.shoot() //делаем выстрел, осталось 8 патронов
    }
}
/*Здесь в роли Originator выступает класс Hero, состояние которого описывается количество патронов и жизней. Для хранения состояния игрового персонажа предназначен класс HeroMemento. С помощью метода SaveState() объект Hero может сохранить свое состояние в HeroMemento, а с помощью метода RestoreState() - восстановить.
 
 Для хранения состояний предназначен класс GameHistory, причем все состояния хранятся в стеке, что позволяет с легкостью извлекать последнее сохраненное состояние.
 
 Использование паттерна Memento дает нам следующие преимущества:
 
 Уменьшение связанности системы
 
 Сохранение инкапсуляции информации
 
 Определение простого интерфейса для сохранения и восстановления состояния
 
 В то же время мы можем столкнуться с недостатками, в частности, если требуется сохранение большого объема информации, то возрастут издержки на хранение всего объема состояния.*/
