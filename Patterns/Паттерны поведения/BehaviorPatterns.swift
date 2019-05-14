//
//  BehaviorPatterns.swift
//  Patterns
//
//  Created by Vlad Gushchin on 14/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct BehaviorPatterns {
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
}
