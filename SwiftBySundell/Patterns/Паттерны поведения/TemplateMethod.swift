//
//  TemplateMethod.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 21/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Шаблонный метод (Template Method) определяет общий алгоритм поведения подклассов, позволяя им переопределить отдельные шаги этого алгоритма без изменения его структуры.
 
 Когда использовать шаблонный метод?
    1)Когда планируется, что в будущем подклассы должны будут переопределять различные этапы алгоритма без изменения его структуры
    2)Когда в классах, реализующим схожий алгоритм, происходит дублирование кода. Вынесение общего кода в шаблонный метод уменьшит его дублирование в подклассах.
 */

//Формальное представление
/*
 AbstractClass: определяет шаблонный метод TemplateMethod(), который реализует алгоритм. Алгоритм может состоять из последовательности вызовов других методов, часть из которых может быть абстрактными и должны быть переопределены в классах-наследниках. При этом сам метод TemplateMethod(), представляющий структуру алгоритма, переопределяться не должен.
 */
fileprivate protocol AbstractClass {
    func operation1()
    func operation2()
}

extension AbstractClass {
    func templateMethod() {
        self.operation1()
        self.operation2()
    }
}

//подкласс, который может переопределять различные методы родительского класса.
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
    //получение аттестата об окончании
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
    func enter()
    func study()
    func passExams()
    func getDocument()
}

extension Education {
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

fileprivate class School_WithTemplateMethod: Education {
    func enter() {
        print("Идем в 1 класс")
    }

    func study() {
        print("Посещаем уроки, делаем домашние задания")
    }

    func getDocument() {
        print("Получаем аттестат о среднем образовании")
    }
}

fileprivate class University_WithTemplateMethod: Education {
    func enter() {
        print("Сдаем вступительные экзамены и поступаем в ВУЗ")
    }

    func study() {
        print("Посещаем лекции")
        print("Проходим практику")
    }

    func passExams() {
        print("Сдаем экзамен по специальности")
    }

    func getDocument() {
        print("Сдаем экзамен по специальности")
    }
}

fileprivate class Programm {
    func main() {
        let school = School_WithTemplateMethod()
        let university = University_WithTemplateMethod()
        school.learn()
        university.learn()
    }
}
