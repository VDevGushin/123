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
// MARK: Мост
StructuralPatterns.bridge()
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


let concurrentTasks = 2

let queue = DispatchQueue(label: "Concurrent queue", attributes: .concurrent)
let sema = DispatchSemaphore(value: concurrentTasks)

var count = 1
for _ in 0..<999 {
    queue.async {
        // Do work
        count += 1
        if count > 0 { print(count) }
        sleep(10)
        sema.signal()
        count = 0
    }
    sema.wait()
}
