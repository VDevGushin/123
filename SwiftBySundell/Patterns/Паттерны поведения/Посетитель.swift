//
//  Посетитель.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 06/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Паттерн Посетитель (Visitor) позволяет определить операцию для объектов других классов без изменения этих классов.
 
 При использовании паттерна Посетитель определяются две иерархии классов: одна для элементов, для которых надо определить новую операцию, и вторая иерархия для посетителей, описывающих данную операцию.
 
 Когда использовать данный паттерн?
 
 Когда имеется много объектов разнородных классов с разными интерфейсами, и требуется выполнить ряд операций над каждым из этих объектов
 
 Когда классам необходимо добавить одинаковый набор операций без изменения этих классов
 
 Когда часто добавляются новые операции к классам, при этом общая структура классов стабильна и практически не изменяется
*/

//интерфейс посетителя, который определяет метод Visit() для каждого объекта Element
fileprivate protocol Visitor {
    func visitElement(element: Element)
}

//конкретные классы посетителей, реализуют интерфейс, определенный в Visitor.
fileprivate class ConcreteVisitor1: Visitor {
    func visitElement(element: Element) {
        element.operation()
    }
}

fileprivate class ConcreteVisitor2: Visitor {
    func visitElement(element: Element) {
        element.operation()
    }
}

//определяет метод Accept(), в котором в качестве параметра принимается объект Visitor
fileprivate protocol Element {
    var state: String { get set }
    func accept(visitor: Visitor)
    func operation()
}

fileprivate class ElementA: Element {
    var state: String = "init state"

    func accept(visitor: Visitor) {
        visitor.visitElement(element: self)
    }

    func operation() {

    }
}

fileprivate class ElementB: Element {
    var state: String = "init state"

    func accept(visitor: Visitor) {
        visitor.visitElement(element: self)
    }

    func operation() {

    }
}

//некоторая структура, которая хранит объекты Element и предоставляет к ним доступ. Это могут быть и простые списки, и сложные составные структуры в виде деревьев

fileprivate class ObjectStructure {
    var elements = [Element]()

    func add(element: Element) {
        self.elements.append(element)
    }

    func remove(element: Element) {
        self.elements.removeAll {
            $0.state == $0.state
        }
    }

    func accept(visitor: Visitor) {
        self.elements.forEach {
            $0.accept(visitor: visitor)
        }
    }
}

fileprivate func main() {
    let objectStructure = ObjectStructure()
    objectStructure.add(element: ElementA())
    objectStructure.add(element: ElementB())
    objectStructure.accept(visitor: ConcreteVisitor1())
    objectStructure.accept(visitor: ConcreteVisitor2())
}

/*Рассмотрим на примере. Как известно, нередко для разных категорий вкладчиков банки имеют свои правила: оформления вкладов, выдача кредитов, начисления процентов и т.д. Соответственно классы, описывающие данные объекты, тоже будут разными. Но что важно, как правило, правила обслуживания четко описает весь набор категорий клиентов. Например, есть физические лица, есть юридические, отдельные правила для индивидуальных или частных предпринимателей и т.д. Поэтому структура классов, представляющая клиентов будет относительно фиксированной, то есть не склонной к изменениям.
 
 И допустим, в какой-то момент мы решили добавить в классы клиентов функционал сериализации в html. В этом случае мы могли бы построить следующую структуру классов:
 
 Каждый класс имеет свой набор свойств и с помощью метода ToHtml() создает таблицу со значениями этих свойств. Но допустим, мы решили добавить потом еще сериализацию в формат xml. Задача относительно проста: добавить в интерфейс IAccount новый метод ToXml() и реализовать его в классах Person и Company.
 
 Но еще через некоторое время мы захотим добавить сериализацию в формат json. Однако в будущем могут появиться новые форматы, которые мы также захотим поддерживать. Частое внесение изменение в фиксированную структуру классов в данном случае не будет оптимально. И для решения этой задачи воспользуемся паттерном Посетитель:*/

fileprivate protocol Account {
    func toHTML()
}

// физическое лицо
fileprivate struct Person: Account, VisitorAccount {
    func accept(visitor: AccountVisitor) {
        visitor.visit(person: self)
    }

    var FIO: String
    var accNumber: String

    func toHTML() {
        var result = "<table><tr><td>Свойство<td><td>Значение</td></tr>"
        result += "<tr><td>FIO<td><td>" + FIO + "</td></tr>"
        result += "<tr><td>Number<td><td>" + accNumber + "</td></tr></table>"
        print(result)
    }
}

// юридическое лицо
fileprivate struct Company: Account, VisitorAccount {
    func accept(visitor: AccountVisitor) {
        visitor.visit(company: self)
    }

    var name: String
    var number: String
    var regNumber: String

    func toHTML() {
        var result = "<table><tr><td>Свойство<td><td>Значение</td></tr>";
        result += "<tr><td>Name<td><td>" + name + "</td></tr>";
        result += "<tr><td>RegNumber<td><td>" + regNumber + "</td></tr>";
        result += "<tr><td>Number<td><td>" + number + "</td></tr></table>";
        print(result);
    }
}

/* Каждый класс имеет свой набор свойств и с помощью метода ToHtml() создает таблицу со значениями этих свойств. Но допустим, мы решили добавить потом еще сериализацию в формат xml. Задача относительно проста: добавить в интерфейс IAccount новый метод ToXml() и реализовать его в классах Person и Company.
 
 Но еще через некоторое время мы захотим добавить сериализацию в формат json. Однако в будущем могут появиться новые форматы, которые мы также захотим поддерживать. Частое внесение изменение в фиксированную структуру классов в данном случае не будет оптимально. И для решения этой задачи воспользуемся паттерном Посетитель:*/

fileprivate protocol AccountVisitor {
    func visit(person: Person)
    func visit(company: Company)
}

// сериализатор в HTML
fileprivate class HtmlVisitor: AccountVisitor {
    func visit(person: Person) {
        var result = "<table><tr><td>Свойство<td><td>Значение</td></tr>"
        result += "<tr><td>Name<td><td>" + person.FIO + "</td></tr>"
        result += "<tr><td>Number<td><td>" + person.accNumber + "</td></tr></table>"
        print(result);
    }

    func visit(company: Company) {
        var result = "<table><tr><td>Свойство<td><td>Значение</td></tr>"
        result += "<tr><td>Name<td><td>" + company.name + "</td></tr>"
        result += "<tr><td>RegNumber<td><td>" + company.regNumber + "</td></tr>"
        result += "<tr><td>Number<td><td>" + company.number + "</td></tr></table>"
        print(result)
    }
}

// сериализатор в XML
fileprivate class XmlVisitor: AccountVisitor {
    func visit(person: Person) {
        let result = "<Person><Name>" + person.FIO + "</Name>" +
            "<Number>" + person.accNumber + "</Number><Person>"
        print(result)
    }

    func visit(company: Company) {
        let result = "<Company><Name>" + company.name + "</Name>" +
            "<RegNumber>" + company.regNumber + "</RegNumber>" +
            "<Number>" + company.number + "</Number><Company>"
        print(result)
    }
}

fileprivate protocol VisitorAccount {
    func accept(visitor: AccountVisitor)
}


fileprivate class Bank {
    var accounts = [VisitorAccount]()
    func add(account: VisitorAccount) {
        self.accounts.append(account)
    }

    func accept(visitor: AccountVisitor) {
        self.accounts.forEach {
            $0.accept(visitor: visitor)
        }
    }
}

fileprivate func main2() {
    let bank = Bank()
    bank.add(account: Person(FIO: "Ivan Alekseev", accNumber: "234124"))
    bank.add(account: Company(name: "Microsoft", number: "1231", regNumber: "32412"))
    bank.accept(visitor: HtmlVisitor())
    bank.accept(visitor: XmlVisitor())
}
