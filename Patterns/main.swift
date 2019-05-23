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
// MARK: фабричный метод
GeneratingPatterns.testFactoryMethod()
print("====================")
// MARK: абстрактная фабрика
GeneratingPatterns.testAbstractFactory()
print("====================")
// MARK: прототип
GeneratingPatterns.testPrototype()
print("====================")
// MARK: строитель
GeneratingPatterns.testBuilder()

// MARK: - Структурные паттерны
print("Структурные паттерны========================================================================")
// MARK: декоратор
StructuralPatterns.decorator()
print("====================")
// MARK: адаптер
StructuralPatterns.adapter()
// MARK: фасад
StructuralPatterns.facade()
// MARK: Компоновщик
StructuralPatterns.composite()
// MARK: Заместитель
StructuralPatterns.proxy()
// MARK: - Паттерны поведения
print("Паттерны поведения==========================================================================")
// MARK: посредник
BehaviorPatterns.mediator()
print("====================")
// MARK: стратегия
BehaviorPatterns.strategy()
print("====================")
// MARK: Цепочка обязанностей
BehaviorPatterns.chainOfResponsibility()
// MARK: Состояние
BehaviorPatterns.state()
// MARK: Посетитель
BehaviorPatterns.visitor()
// MARK: Хранитель
BehaviorPatterns.memento()
