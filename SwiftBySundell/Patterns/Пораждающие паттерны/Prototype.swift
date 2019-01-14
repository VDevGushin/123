//
//  Prototype.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 14/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*
 Паттерн Прототип (Prototype) позволяет создавать объекты на основе уже ранее созданных объектов-прототипов.
 То есть по сути данный паттерн предлагает технику клонирования объектов.

 Когда использовать Прототип:
    1)Когда конкретный тип создаваемого объекта должен определяться динамически во время выполнения
    2)Когда нежелательно создание отдельной иерархии классов фабрик для создания объектов-продуктов из параллельной иерархии классов (как это делается, например, при использовании паттерна Абстрактная фабрика)
    3)Когда клонирование объекта является более предпочтительным вариантом нежели его создание и инициализация с помощью конструктора. Особенно когда известно, что объект может принимать небольшое ограниченное число возможных состояний.
 */
//Формальная структура паттерна

//определяет интерфейс для клонирования самого себя, который, как правило, представляет метод Clone(
fileprivate protocol Prototype {
    var id: Int { get set }
    func clone() -> Prototype
}

//конкретные реализации прототипа. Реализуют метод Clone()
fileprivate class ConcretePrototype1: Prototype {
    var id: Int
    init(id: Int) {
        self.id = id
    }

    func clone() -> Prototype {
        return ConcretePrototype1(id: id)
    }
}

fileprivate class ConcretePrototype2: Prototype {
    var id: Int
    init(id: Int) {
        self.id = id
    }

    func clone() -> Prototype {
        return ConcretePrototype2(id: id)
    }
}

//создает объекты прототипов с помощью метода Clone()
fileprivate class Client {
    func main() {
        var prototype: Prototype = ConcretePrototype1(id: 1)
        var clone = prototype.clone()
        prototype = ConcretePrototype2(id: 2)
        clone = prototype.clone()
        dump(clone)
    }
}

// Рассмотрим клонирование на примере фигур - прямоугольников и кругов:

fileprivate protocol IFigure {
    func clone() -> IFigure
    func getInfo()
}

fileprivate class Rectangle: IFigure {
    let width, height: Int

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    func clone() -> IFigure {
        return Rectangle(width: self.width, height: self.height)
    }

    func getInfo() {
        print("Прямоугольник длиной \(width) и шириной \(height)")
    }
}

fileprivate class Circle: IFigure {
    let radius: Int
    init(radius: Int) {
        self.radius = radius
    }

    func clone() -> IFigure {
        return Circle(radius: self.radius)
    }

    func getInfo() {
        print("Круг радиусом \(self.radius)")
    }
}

fileprivate class FigureClient {
    func main() {
        let figure: IFigure = Rectangle(width: 30, height: 30)
        let clonedFigure: IFigure = figure.clone()
        figure.getInfo()
        clonedFigure.getInfo()
    }
}
