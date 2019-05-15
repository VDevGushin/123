//
//  main.swift
//  Patterns
//
//  Created by Vlad Gushchin on 14/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
// MARK: - Порождающие паттерны
print("Порождающие паттерны========================================================================")
GeneratingPatterns.testFactoryMethod()
print("====================")
GeneratingPatterns.testAbstractFactory()
print("====================")
GeneratingPatterns.testPrototype()
print("====================")
GeneratingPatterns.testBuilder()

// MARK: - Структурные паттерны
print("Структурные паттерны========================================================================")
StructuralPatterns.testDecorator()

// MARK: - Паттерны поведения
print("Паттерны поведения==========================================================================")
BehaviorPatterns.mediator()
print("====================")
BehaviorPatterns.strategy()
print("============================================================================================")



