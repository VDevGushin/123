//
//  Bridge.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 18/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Мост (Bridge) - структурный шаблон проектирования, который позволяет отделить абстракцию от реализации таким образом, чтобы и абстракцию, и реализацию можно было изменять независимо друг от друга.
 
 Даже если мы отделим абстракцию от конкретных реализаций, то у нас все равно все наследуемые классы будут жестко привязаны к интерфейсу, определяемому в базовом абстрактном классе. Для преодоления жестких связей и служит паттерн Мост.
 
 Когда использовать данный паттерн?
 
 Когда надо избежать постоянной привязки абстракции к реализации
 
 Когда наряду с реализацией надо изменять и абстракцию независимо друг от друга. То есть изменения в абстракции не должно привести к изменениям в реализации
 
 Общая реализация паттерна состоит в объявлении классов абстракций и классов реализаций в отдельных параллельных иерархиях классов.*/

// определяет базовый интерфейс и хранит ссылку на объект Implementor. Выполнение операций в Abstraction делегируется методам объекта Implementor
fileprivate protocol Abstraction {
    var implemetor: Implementor { get set }
    init (implemetor: Implementor)

    func operation()
}

extension Abstraction {
    func operation() {
        self.implemetor.operationImp()
    }
}

//определяет базовый интерфейс для конкретных реализаций. Как правило, Implementor определяет только примитивные операции. Более сложные операции, которые базируются на примитивных, определяются в Abstraction
fileprivate protocol Implementor {
    func operationImp()
}

// уточненная абстракция, наследуется от Abstraction и расширяет унаследованный интерфейс
fileprivate class RefinedAbstraction: Abstraction {
    var implemetor: Implementor

    required init(implemetor: Implementor) {
        self.implemetor = implemetor
    }
}

//конкретные реализации, которые унаследованы от Implementor
fileprivate class ConcreteImplementorA: Implementor {
    func operationImp() {
    }
}

fileprivate class ConcreteImplementorB: Implementor {
    func operationImp() {
    }
}

fileprivate class Client {
    func main() {
        var abstration: Abstraction = RefinedAbstraction(implemetor: ConcreteImplementorA())
        abstration.operation()
        abstration.implemetor = ConcreteImplementorB()
        abstration.operation()
    }
}

/*Теперь рассмотрим реальное применение. Существует множество программистов, но одни являются фрилансерами, кто-то работает в компании инженером, кто-то совмещает работу в компании и фриланс. Таким образом, вырисовывается иерархия различных классов программистов. Но эти программисты могут работать с различными языками и технологиями. И в зависимости от выбранного языка деятельность программиста будет отличаться. Для решения описания данной задачи в программе на C# используем паттерн Мост:*/

///////////////////////////Язык программирования
fileprivate protocol Language {
    func build()
    func execute()
}

fileprivate class CPPLanguage: Language {
    func build() {
        print("С помощью компилятора C++ компилируем программу в бинарный код")
    }

    func execute() {
        print("Запускаем исполняемый файл программы")
    }
}

fileprivate class CSharpLanguage: Language {
    func build() {
        print("С помощью компилятора Roslyn компилируем исходный код в файл exe")
    }

    func execute() {
        print("JIT компилирует программу бинарный код")
        print("CLR выполняет скомпилированный бинарный код")
    }
}

///////////////////////////Программисты
fileprivate protocol Programmer {
    var language: Language { get set }
    init(language: Language)
    func doWork()
    func earnMoney()
}

fileprivate extension Programmer {
    func doWork() {
        self.language.build()
        self.language.execute()
    }
}

fileprivate class FreelanceProgrammer: Programmer {
    var language: Language

    required init(language: Language) {
        self.language = language
    }

    func earnMoney() {
        print("Получаем оплату за выполненный заказ")
    }
}

fileprivate class CorporateProgrammer: Programmer {
    var language: Language

    required init(language: Language) {
        self.language = language
    }

    func earnMoney() {
        print("Получаем в конце месяца зарплату")
    }
}

fileprivate class Program {
    func main() {
        var programmer: Programmer = FreelanceProgrammer(language: CPPLanguage())
        programmer.doWork()
        programmer.earnMoney()
        programmer.language = CSharpLanguage()
        programmer.doWork()
        programmer.earnMoney()
    }
}
