//
//  Facade.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 12/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Фасад (Facade) представляет шаблон проектирования, который позволяет скрыть сложность системы с помощью предоставления упрощенного интерфейса для взаимодействия с ней.
 
 Когда использовать фасад?
 
 Когда имеется сложная система, и необходимо упростить с ней работу. Фасад позволит определить одну точку взаимодействия между клиентом и системой.
 
 Когда надо уменьшить количество зависимостей между клиентом и сложной системой. Фасадные объекты позволяют отделить, изолировать компоненты системы от клиента и развивать и работать с ними независимо.
 
 Когда нужно определить подсистемы компонентов в сложной системе. Создание фасадов для компонентов каждой отдельной подсистемы позволит упростить взаимодействие между ними и повысить их независимость друг от друга.
 
 В UML общую схему фасада можно представить следующим образом:*/

//Классы SubsystemA, SubsystemB, SubsystemC и т.д. являются компонентами сложной подсистемы, с которыми должен взаимодействовать клиент
fileprivate class SustemA {
    func a() { }
}

fileprivate class SustemB {
    func b() { }
}

fileprivate class SustemC {
    func c() { }
}

//Facade - непосредственно фасад, который предоставляет интерфейс клиенту для работы с компонентами
fileprivate class Facade {
    private let sustemA: SustemA
    private let sustemB: SustemB
    private let sustemC: SustemC

    init(sustemA: SustemA, sustemB: SustemB, sustemC: SustemC) {
        self.sustemA = sustemA
        self.sustemB = sustemB
        self.sustemC = sustemC
    }

    func operation1() {
        sustemA.a()
        sustemB.b()
        sustemC.c()
    }

    func operation2() {
        sustemB.b()
        sustemC.c()
    }
}

fileprivate class Client {
    func main() {
        let facade = Facade(sustemA: SustemA(), sustemB: SustemB(), sustemC: SustemC())
        facade.operation1()
        facade.operation2()
    }
}

//==============================================================================================================================

fileprivate class TextEditor {
    func createCode() {
        print("Написание кода")
    }

    func save() {
        print("Сохранение кода")
    }
}

fileprivate class Compiller {
    func compile() {
        print("Компиляция приложения")
    }
}

fileprivate class CLR {
    func execute() {
        print("Выполнение приложения")
    }

    func finish() {
        print("Завершение работы приложения")
    }
}

fileprivate class XcodeFacade {
    private let textEditor: TextEditor
    private let compiller: Compiller
    private let clr: CLR

    init(textEditor: TextEditor, compiller: Compiller, clr: CLR) {
        self.textEditor = textEditor
        self.clr = clr
        self.compiller = compiller
    }

    func start() {
        textEditor.createCode()
        textEditor.save()
        compiller.compile()
        clr.execute()
    }

    func stop() {
        clr.finish()
    }
}

fileprivate class Programmer {
    func createApplication(xcode: XcodeFacade) {
        xcode.start()
        xcode.stop()
    }
}

fileprivate class Programm {
    func main() {
        let textEditor = TextEditor()
        let compiller = Compiller()
        let clr = CLR()
        let ide = XcodeFacade(textEditor: textEditor, compiller: compiller, clr: clr)

        let programmer = Programmer()
        programmer.createApplication(xcode: ide)
    }
}
