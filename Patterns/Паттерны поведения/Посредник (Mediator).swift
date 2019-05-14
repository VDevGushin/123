//
//  Посредник (Mediator).swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 13/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Паттерн Посредник (Mediator) представляет такой шаблон проектирования, который обеспечивает взаимодействие множества объектов без необходимости ссылаться друг на друга. Тем самым достигается слабосвязанность взаимодействующих объектов.
 
 Когда используется паттерн Посредник?
 1) Когда имеется множество взаимосвязаных объектов, связи между которыми сложны и запутаны.
 2) Когда необходимо повторно использовать объект, однако повторное использование затруднено в силу сильных связей с другими объектами.*/


fileprivate protocol Mediator {
    func send(message: String, colleague: Colleague)
}

fileprivate class ConcreteMediator: Mediator {
    private let colleague1: ConcreteColleague1
    private let colleague2: ConcreteColleague2

    init(colleague1: ConcreteColleague1, colleague2: ConcreteColleague2) {
        self.colleague2 = colleague2
        self.colleague1 = colleague1
    }

    func send(message: String, colleague: Colleague) {
        if self.colleague1 === colleague {
            self.colleague1.notify(message: message)
        } else {
            self.colleague2.notify(message: message)
        }
    }
}


fileprivate protocol Colleague: class {
    init(mediator: Mediator)
}

fileprivate class ConcreteColleague1: Colleague {
    private let mediator: Mediator

    required init(mediator: Mediator) {
        self.mediator = mediator
    }

    func send(message: String) {
        self.mediator.send(message: message, colleague: self)
    }

    func notify(message: String) {
        print(message)
    }
}

fileprivate class ConcreteColleague2: Colleague {
    private let mediator: Mediator

    required init(mediator: Mediator) {
        self.mediator = mediator
    }

    func send(message: String) {
        self.mediator.send(message: message, colleague: self)
    }

    func notify(message: String) {
        print(message)
    }
}

/*Рассмотрим реальный пример.
 Система создания программных продуктов включает ряд акторов: заказчики, программисты, тестировщики и так далее.
 Но нередко все эти акторы взаимодействуют между собой не непосредственно, а опосредованно через менеджера проектов.
 То есть менеджер проектов выполняет роль посредника.
 В этом случае процесс взаимодействия между объектами мы могли бы описать так:*/

protocol MediatorTemplate {
    func send(message: String, colleague: ColleagueTemplate)
}

class Manager: MediatorTemplate {
    private var team: [ColleagueTemplate] = []

    func add(team: [ColleagueTemplate]) {
        self.team = team
    }

    func send(message: String, colleague: ColleagueTemplate) {
        for member in self.team {
            switch colleague {
            case is CustomerColleague:
                if member is ProgrammerColleague { member.notify(message: message) }
            case is ProgrammerColleague:
                if member is TesterColleague { member.notify(message: message) }
            case is TesterColleague:
                if member is CustomerColleague { member.notify(message: message) }
            default:
                continue
            }
        }
    }
}

protocol ColleagueTemplate {
    init(mediator: MediatorTemplate)
    func send(message: String)
    func notify(message: String)
}

// класс заказчика
class CustomerColleague: ColleagueTemplate {
    private let mediator: MediatorTemplate

    required init(mediator: MediatorTemplate) {
        self.mediator = mediator
    }

    func send(message: String) {
        self.mediator.send(message: message, colleague: self)
    }

    func notify(message: String) {
        print("Сообщение заказчику \(message)")
    }
}

// класс программиста
class ProgrammerColleague: ColleagueTemplate {
    private let mediator: MediatorTemplate

    required init(mediator: MediatorTemplate) {
        self.mediator = mediator
    }

    func send(message: String) {
        self.mediator.send(message: message, colleague: self)
    }

    func notify(message: String) {
        print("Сообщение программисту \(message)")
    }
}

// класс тестера
class TesterColleague: ColleagueTemplate {
    private let mediator: MediatorTemplate

    required init(mediator: MediatorTemplate) {
        self.mediator = mediator
    }

    func send(message: String) {
        self.mediator.send(message: message, colleague: self)
    }

    func notify(message: String) {
        print("Сообщение тестеру \(message)")
    }
}
