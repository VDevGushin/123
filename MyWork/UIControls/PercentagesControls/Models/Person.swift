//
//  Person.swift
//  MyWork
//
//  Created by Vladislav Gushin on 30/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

class Person {
    let name: String
    let variant: PercentagesSource.Variant
    let statistic: RoundPercentagesSource
    init(name: String, variant: PercentagesSource.Variant, statistic: RoundPercentagesSource) {
        self.name = name
        self.variant = variant
        self.statistic = statistic
    }
}
