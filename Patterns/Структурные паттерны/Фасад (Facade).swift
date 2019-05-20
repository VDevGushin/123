//
//  Фасад (Facade).swift
//  Patterns
//
//  Created by Vlad Gushchin on 20/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Фасад (Facade) представляет шаблон проектирования, который позволяет скрыть сложность системы с помощью предоставления упрощенного интерфейса для взаимодействия с ней.
 
 Когда использовать фасад?
 
 Когда имеется сложная система, и необходимо упростить с ней работу. Фасад позволит определить одну точку взаимодействия между клиентом и системой.
 
 Когда надо уменьшить количество зависимостей между клиентом и сложной системой. Фасадные объекты позволяют отделить, изолировать компоненты системы от клиента и развивать и работать с ними независимо.
 
 Когда нужно определить подсистемы компонентов в сложной системе. Создание фасадов для компонентов каждой отдельной подсистемы позволит упростить взаимодействие между ними и повысить их независимость друг от друга.*/

fileprivate struct SubSystemA {
    func a1() { }
}

fileprivate struct SubSystemB {
    func b1() { }
}

fileprivate struct SubSystemC {
    func c1() { }
}

fileprivate struct Facade {
    let subsystemA: SubSystemA
    let subsystemB: SubSystemB
    let subsystemC: SubSystemC

    func operation1() {
        self.subsystemA.a1()
        self.subsystemB.b1()
        self.subsystemC.c1()
    }

    func operation2() {
        self.subsystemA.a1()
        self.subsystemC.c1()
    }
}

fileprivate class Client {
    func main() {
        let facade = Facade(subsystemA: SubSystemA(), subsystemB: SubSystemB(), subsystemC: SubSystemC())
        facade.operation1()
        facade.operation2()
    }
}

/*Рассмотрим применение паттерна в реальной задаче. Думаю, большинство программистов согласятся со мной, что писать в Visual Studio код одно удовольствие по сравнению с тем, как писался код ранее до появления интегрированных сред разработки. Мы просто пишем код, нажимаем на кнопку и все - приложение готово. В данном случае интегрированная среда разработки представляет собой фасад, который скрывает всю сложность процесса компиляции и запуска приложения. Теперь опишем этот фасад в программе на C#:*/

struct TextEditor {
    func createCode() {
        print("Написание кода")
    }

    func save() {
        print("Cохранение кода")
    }
}

struct Compiller {
    func compile() {
        print("Компиляция приложения")
    }
}

struct CLR {
    func execute() {
        print("Выполнение приложения")
    }

    func finish() {
        print("Завершение работы приложения")
    }
}

struct VisualStudioFacade {
    let textEditor: TextEditor
    let compiller: Compiller
    let clr: CLR

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

struct Programmer {
    func createApplication(with ide: VisualStudioFacade) {
        ide.start()
        ide.stop()
    }
}

func testFacade(){
    let textEditor = TextEditor()
    let compiller = Compiller()
    let clr = CLR()
    
    let ide = VisualStudioFacade(textEditor: textEditor, compiller: compiller, clr: clr)
    let programmer = Programmer()
    programmer.createApplication(with: ide)    
}

