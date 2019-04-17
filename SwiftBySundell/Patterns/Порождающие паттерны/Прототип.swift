//
//  Прототип.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 17/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*Паттерн Прототип (Prototype) позволяет создавать объекты на основе уже ранее созданных объектов-прототипов. То есть по сути данный паттерн предлагает технику клонирования объектов.
 
 Когда использовать Прототип?
 1) Когда конкретный тип создаваемого объекта должен определяться динамически во время выполнения

 2) Когда нежелательно создание отдельной иерархии классов фабрик для создания объектов-продуктов из параллельной иерархии классов (как это делается, например, при использовании паттерна Абстрактная фабрика)
 
 3) Когда клонирование объекта является более предпочтительным вариантом нежели его создание и инициализация с помощью конструктора. Особенно когда известно, что объект может принимать небольшое ограниченное число возможных состояний.
 */

fileprivate protocol Prototype {
    var id: Int { get set }
    func clone() -> Prototype
}

fileprivate class ConcretePrototype1: Prototype {
    var id: Int

    init(id: Int) {
        self.id = id
    }

    func clone() -> Prototype {
        return ConcretePrototype1(id: self.id);
    }
}

fileprivate class ConcretePrototype2: Prototype {
    var id: Int

    init(id: Int) {
        self.id = id
    }

    func clone() -> Prototype {
        return ConcretePrototype2(id: self.id);
    }
}

fileprivate func main() {
    let prototype = ConcretePrototype1(id: 1)
    let clone = prototype.clone()
    dump(clone)
}

//Рассмотрим клонирование на примере фигур - прямоугольников и кругов:

fileprivate protocol Figure {
    func clone() -> Self
    func getInfo()
}

fileprivate struct Rectangle: Figure {
    private let width, height: Int

    func clone() -> Rectangle {
        return Rectangle(width: self.width, height: self.height)
    }

    func getInfo() {
        print("Прямоуголник [\(self.width):\(self.height)]")
    }
}

fileprivate struct Circle: Figure {
    private let radius: Int
    private let point: CGPoint
    
    func clone() -> Circle {
        return Circle(radius: self.radius, point: self.point)
    }

    func getInfo() {
        print("Круг [\(self.radius)]")
    }
}
