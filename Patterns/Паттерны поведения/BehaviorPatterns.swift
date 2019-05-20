//
//  BehaviorPatterns.swift
//  Patterns
//
//  Created by Vlad Gushchin on 14/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct BehaviorPatterns {
    // Посредник
    static func mediator() {
        let manager = Manager()
        let customer = CustomerColleague(mediator: manager)
        let programmer = ProgrammerColleague(mediator: manager)
        let tester = TesterColleague(mediator: manager)
        manager.add(team: [customer, programmer, tester])

        customer.send(message: "Есть заказ, надо сделать программу")
        programmer.send(message: "Программа готова, надо протестировать")
        tester.send(message: "Программа протестированна и готова к продаже")
    }

    // Стратегия
    static func strategy() {
        let auto = Car(passengers: 4, model: "Volvo", movable: PetrolMove())
        auto.move()
        auto.movable = ElectricMove()
        auto.move()
    }

    // Цепочка обязанностей
    static func chainOfResponsibility() {
        testChainOfResponsibility()
    }
    
    // Состояние
    static func state() {
        testState()
    }
}
