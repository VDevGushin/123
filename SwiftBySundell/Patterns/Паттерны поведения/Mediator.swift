//
//  Mediator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 29/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Паттерн Посредник (Mediator) представляет такой шаблон проектирования, который обеспечивает взаимодействие множества объектов без необходимости ссылаться друг на друга. Тем самым достигается слабосвязанность взаимодействующих объектов.
 
 Когда используется паттерн Посредник?
 
 Когда имеется множество взаимосвязаных объектов, связи между которыми сложны и запутаны.
 
 Когда необходимо повторно использовать объект, однако повторное использование затруднено в силу сильных связей с другими объектами.
 */
//Формальное определение:

// Mediator: представляет интерфейс для взаимодействия с объектами Colleague
fileprivate protocol Mediator {
    func send(message: String, colleague: Colleague)
}

//Colleague: представляет интерфейс для взаимодействия с объектом Mediator
fileprivate protocol Colleague: class {
    var mediator: Mediator { get set }
    init(mediator: Mediator)
    func send(message: String)
    func notify(message: String)
}

extension Colleague {
    func send(message: String) {
        mediator.send(message: message, colleague: self)
    }
}

//ConcreteColleague1 и ConcreteColleague2: конкретные классы коллег, которые обмениваются друг с другом через объект Mediator
fileprivate class ConcreteColleague1: Colleague {
    var mediator: Mediator

    required init(mediator: Mediator) {
        self.mediator = mediator
    }

    func send(message: String) {
        self.mediator.send(message: message, colleague: self)
    }

    func notify(message: String) { }
}

fileprivate class ConcreteColleague2: Colleague {
    var mediator: Mediator

    required init(mediator: Mediator) {
        self.mediator = mediator
    }

    func send(message: String) {
        self.mediator.send(message: message, colleague: self)
    }

    func notify(message: String) { }
}

// конкретный посредник, реализующий интерфейс типа Mediator
fileprivate class ConcreteMediator: Mediator {
    var colleague1: ConcreteColleague1?
    var colleague2: ConcreteColleague2?

    func send(message: String, colleague: Colleague) {
        if colleague1 === colleague {
            colleague2?.notify(message: message)
        } else {
            colleague1?.notify(message: message)
        }
    }
}

/*Рассмотрим реальный пример. Система создания программных продуктов включает ряд акторов: заказчики, программисты, тестировщики и так далее. Но нередко все эти акторы взаимодействуют между собой не непосредственно, а опосредованно через менеджера проектов. То есть менеджер проектов выполняет роль посредника. В этом случае процесс взаимодействия между объектами мы могли бы описать так:*/

// класс заказчика
fileprivate class CustomerColleague: Colleague {
    var mediator: Mediator

    required init(mediator: Mediator) {
        self.mediator = mediator
    }

    func notify(message: String) {
        print("Сообщение заказчику")
    }
}

// класс программиста
fileprivate class ProgrammerColleague: Colleague {
    var mediator: Mediator

    required init(mediator: Mediator) {
        self.mediator = mediator
    }

    func notify(message: String) {
        print("Сообщение программисту")
    }
}

// класс тестера
fileprivate class TesterColleague: Colleague {
    var mediator: Mediator

    required init(mediator: Mediator) {
        self.mediator = mediator
    }

    func notify(message: String) {
        print("Сообщение тестеру")
    }
}

fileprivate class ManagerMediator: Mediator {
    var customer: CustomerColleague?
    var programmer: ProgrammerColleague?
    var tester: TesterColleague?

    func send(message: String, colleague: Colleague) {
        // если отправитель - заказчик, значит есть новый заказ
        // отправляем сообщение программисту - выполнить заказ
        if colleague === self.customer {
            self.programmer?.notify(message: message)
        }
        // если отправитель - программист, то можно приступать к тестированию
        // отправляем сообщение тестеру
            else if colleague === self.programmer {
                self.tester?.notify(message: message)
        }
        // если отправитель - тест, значит продукт готов
        // отправляем сообщение заказчику
            else if colleague === self.tester {
                self.customer?.notify(message: message)
        }
    }
}

fileprivate class Program {
    func main() {
        let mediator = ManagerMediator()
        let customer = CustomerColleague(mediator: mediator)
        let programmer = ProgrammerColleague(mediator: mediator)
        let tester = TesterColleague(mediator: mediator)

        mediator.customer = customer
        mediator.programmer = programmer
        mediator.tester = tester
        
        customer.send(message: "Есть заказ, надо сделать программму")
        programmer.send(message: "Программа готова, надо протестировать")
        tester.send(message: "Программа протестированна и готова к продаже")
    }
}
