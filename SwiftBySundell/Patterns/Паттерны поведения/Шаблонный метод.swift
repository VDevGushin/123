//
//  Шаблонный метод.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 24/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*
 Шаблонный метод (Template Method) определяет общий алгоритм поведения подклассов, позволяя им переопределить отдельные шаги этого алгоритма без изменения его структуры.
 
 Когда использовать шаблонный метод?
    1)Когда планируется, что в будущем подклассы должны будут переопределять различные этапы алгоритма без изменения его структуры
    2)Когда в классах, реализующим схожий алгоритм, происходит дублирование кода. Вынесение общего кода в шаблонный метод уменьшит его дублирование в подклассах.
 */

fileprivate protocol AbstractClass {
    func operation1()
    func operation2()
    func templateMethod()
}

fileprivate extension AbstractClass {
    func templateMethod() {
        print("template method")
    }
}

fileprivate class ConcreteClass: AbstractClass {
    func operation1() { }
    func operation2() { }
}

//Рассмотрим применение на конкретном примере. Допустим, в нашей программе используются объекты, представляющие учебу в школе и в вузе:
fileprivate class School {
    // идем в первый класс
    func enter() { }
    // обучение
    func study() { }
    // сдаем выпускные экзамены
    func passExams() { }
    // получение аттестата об окончании
    func getAttestat() { }
}

fileprivate class University {
    // поступление в университет
    func enter() { }
    // обучение
    func study() { }
    // проходим практику
    func practice() { }
    // сдаем выпускные экзамены
    func passExams() { }
    // получение диплома
    func getDiploma() { }
}
/*Как видно, эти классы очень похожи, и самое главное, реализуют примерно общий алгоритм. Да, где-то будет отличаться реализация методов, где-то чуть больше методов, но в целом мы имеем общий алгоритм, а функциональность обоих классов по большому счету дублируется. Поэтому для улучшения структуры классов мы могли бы применить шаблонный метод:*/

fileprivate protocol Education {
    func learn()
    func enter();
    func study();
    func passExams()
    func getDocument();
}

fileprivate extension Education {
    func learn() {
        self.enter()
        self.study()
        self.passExams()
        self.getDocument()
    }

    func passExams() {
        print("Сдаем выпускные экзамены")
    }
}

fileprivate class School1: Education {
    func enter() { }
    func study() { }
    func getDocument() { }
}

fileprivate class University1: Education {
    func enter() { }
    func study() { }
    func getDocument() { }
}
