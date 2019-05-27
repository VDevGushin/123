//
//  Мост (Bridge).swift
//  Patterns
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Мост (Bridge) - структурный шаблон проектирования, который позволяет отделить абстракцию от реализации таким образом, чтобы и абстракцию, и реализацию можно было изменять независимо друг от друга.
 
 Даже если мы отделим абстракцию от конкретных реализаций, то у нас все равно все наследуемые классы будут жестко привязаны к интерфейсу, определяемому в базовом абстрактном классе. Для преодоления жестких связей и служит паттерн Мост.
 
 Когда использовать данный паттерн?
 
 Когда надо избежать постоянной привязки абстракции к реализации
 
 Когда наряду с реализацией надо изменять и абстракцию независимо друг от друга. То есть изменения в абстракции не должно привести к изменениям в реализации*/


//class Client
//{
//    static void Main()
//{
//    Abstraction abstraction;
//    abstraction = new RefinedAbstraction(new ConcreteImplementorA());
//    abstraction.Operation();
//    abstraction.Implementor=new ConcreteImplementorB();
//    abstraction.Operation();
//    }
//}

//Abstraction: определяет базовый интерфейс и хранит ссылку на объект Implementor.
//Выполнение операций в Abstraction делегируется методам объекта Implementor
fileprivate protocol Abstraction {
    var implementor: Implementor { get set }
    init(implementor: Implementor)
    func operation()
}

extension Abstraction {
    func operation() {
        self.implementor.operationImp()
    }
}

//Implementor: определяет базовый интерфейс для конкретных реализаций. Как правило, Implementor определяет только примитивные операции. Более сложные операции, которые базируются на примитивных, определяются в Abstraction
fileprivate protocol Implementor {
    func operationImp();
}

//RefinedAbstraction: уточненная абстракция, наследуется от Abstraction и расширяет унаследованный интерфейс

fileprivate class RefinedAbstraction: Abstraction {
    var implementor: Implementor

    required init(implementor: Implementor) {
        self.implementor = implementor
    }

    func operation() {
        //custom
        self.implementor.operationImp()
    }
}

//ConcreteImplementorA и ConcreteImplementorB: конкретные реализации, которые унаследованы от Implementor
fileprivate class ConcreteImplementorA: Implementor {
    func operationImp() { }
}

fileprivate class ConcreteImplementorB: Implementor {
    func operationImp() { }
}

fileprivate func main() {
    let abstraction = RefinedAbstraction(implementor: ConcreteImplementorA())
    abstraction.operation()
    abstraction.implementor = ConcreteImplementorB()
    abstraction.operation()
}

/*Теперь рассмотрим реальное применение.
 Существует множество программистов, но одни являются фрилансерами, кто-то работает в компании инженером, кто-то совмещает работу в компании и фриланс.
 Таким образом, вырисовывается иерархия различных классов программистов. Но эти программисты могут работать с различными языками и технологиями. И в зависимости от выбранного языка деятельность программиста будет отличаться. Для решения описания данной задачи в программе на C# используем паттерн Мост:*/
protocol Language {
    func build()
    func execute()
}

final class CPPLanguage: Language {
    func build() {
        print("С помощью компилятора C++ компилируем программу в бинарный код")
    }

    func execute() {
        print("Запускаем исполняемый файл программы")
    }
}

final class CSharpLanguage: Language {
    func build() {
        print("С помощью компилятора Roslyn компилируем исходный код в файл exe")
    }

    func execute() {
        print("JIT компилирует программу бинарный код")
        print("CLR выполняет скомпилированный бинарный код")
    }
}

protocol ProgrammerBridge {
    var language: Language { get }
    init(language: Language)
    func doWork()
    func earnMoney()
}

extension ProgrammerBridge {
    func doWork() {
        self.language.build()
        self.language.execute()
    }
}

final class FreelanceProgrammer: ProgrammerBridge {
    var language: Language

    init(language: Language) {
        self.language = language
    }

    func earnMoney() {
        print("Получаем оплату за выполненный заказ")
    }
}

final class CorporateProgrammer: ProgrammerBridge {
    var language: Language

    init(language: Language) {
        self.language = language
    }

    func earnMoney() {
        print("Получаем в конце месяца зарплату")
    }
}

func testBridge() {
    let freelancer = FreelanceProgrammer(language: CPPLanguage())
    freelancer.doWork()
    freelancer.earnMoney()

    freelancer.language = CSharpLanguage()
    freelancer.doWork()
    freelancer.earnMoney()
}

/*В роли Abstraction выступает класс Programmer, а в роли Implementor - интерфейс ILanguage, который представляет язык программирования. В методе DoWork() класса Programmer вызываются методы объекта ILanguage.

Языки CPPLanguage и CSharpLanguage определяют конкретные реализации, а классы FreelanceProgrammer и CorporateProgrammer представляют уточненные абстракции.

Таким образом, благодаря применению паттерна реализация отделяется от абстракции. Мы можем развивать независимо две параллельные иерархии. Устраняются зависимости между реализацией и абстракцией во время компиляции, и мы можем менять конкретную реализацию во время выполнения.*/
