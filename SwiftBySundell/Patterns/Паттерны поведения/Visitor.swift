//
//  Visitor.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 01/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Паттерн Посетитель (Visitor) позволяет определить операцию для объектов других классов без изменения этих классов.
 
 При использовании паттерна Посетитель определяются две иерархии классов: одна для элементов, для которых надо определить новую операцию, и вторая иерархия для посетителей, описывающих данную операцию.
 
 Когда использовать данный паттерн?
 
    1)Когда имеется много объектов разнородных классов с разными интерфейсами, и требуется выполнить ряд операций над каждым из этих объектов
 
    2)Когда классам необходимо добавить одинаковый набор операций без изменения этих классов
 
    3)Когда часто добавляются новые операции к классам, при этом общая структура классов стабильна и практически не изменяется*/

// интерфейс посетителя, который определяет метод Visit() для каждого объекта Element
fileprivate protocol Visitor {
    func visitElementA(element: ElementA)
    func visitElementB(element: ElementB)
}

//ConcreteVisitor1 / ConcreteVisitor2: конкретные классы посетителей, реализуют интерфейс, определенный в Visitor.
fileprivate class ConcreteVisitor1: Visitor {
    func visitElementA(element: ElementA) {
        element.operationA()
    }

    func visitElementB(element: ElementB) {
        element.operationB()
    }
}

fileprivate class ConcreteVisitor2: Visitor {
    func visitElementA(element: ElementA) {
        element.operationA()
    }

    func visitElementB(element: ElementB) {
        element.operationB()
    }
}

//определяет метод Accept(), в котором в качестве параметра принимается объект Visitor
fileprivate protocol Element {
    func accept(visitor: Visitor)
    var state: String { get set }
}

//конкретные элементы, которые реализуют метод Accept()
fileprivate class ElementA: Element {
    func accept(visitor: Visitor) {
        visitor.visitElementA(element: self)
    }

    init() {
        self.state = ""
    }

    var state: String

    func operationA() { }
}

fileprivate class ElementB: Element {
    func accept(visitor: Visitor) {
        visitor.visitElementB(element: self)
    }

    init() {
        self.state = ""
    }
    var state: String

    func operationB() {

    }
}

// некоторая структура, которая хранит объекты Element и предоставляет к ним доступ. Это могут быть и простые списки, и сложные составные структуры в виде деревьев
fileprivate struct ObjectStructure {
    var elements = [Element]()

    mutating func add(element: Element) {
        elements.append(element)
    }

    mutating func delete(element: Element) {
        elements.remove(at: 1)
    }

    func accept(visitor: Visitor) {
        self.elements.forEach {
            $0.accept(visitor: visitor)
        }
    }
}

fileprivate class Client {
    func main() {
        var structure = ObjectStructure()
        structure.add(element: ElementA())
        structure.add(element: ElementB())
        structure.accept(visitor: ConcreteVisitor1())
        structure.accept(visitor: ConcreteVisitor2())
    }
}


/*Рассмотрим на примере. Как известно, нередко для разных категорий вкладчиков банки имеют свои правила: оформления вкладов, выдача кредитов, начисления процентов и т.д. Соответственно классы, описывающие данные объекты, тоже будут разными. Но что важно, как правило, правила обслуживания четко описает весь набор категорий клиентов. Например, есть физические лица, есть юридические, отдельные правила для индивидуальных или частных предпринимателей и т.д. Поэтому структура классов, представляющая клиентов будет относительно фиксированной, то есть не склонной к изменениям.
 
 И допустим, в какой-то момент мы решили добавить в классы клиентов функционал сериализации в html. В этом случае мы могли бы построить следующую структуру классов:*/
