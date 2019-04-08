//
//  A detailed explanation of memory leaks.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 05/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*Утечки памяти в iOS могут быть крайне неприятными. Они могут не только вызывать непреднамеренные и неочевидные последствия, например, расплывчатые сбои, но их также трудно отследить.
 Хотя утечки памяти сами по себе не обязательно приводят к сбою приложения, хранение экземпляров объектов дольше, чем должно, может привести к непреднамеренному поведению. Журнал сбоев, приведенный ниже, косвенно является результатом утечки памяти, вызванной циклом сохранения в приложении для iOS.
 
 Утечка памяти происходит, когда система не может определить, используется ли выделенное пространство в памяти или нет. И Swift, и Objective-C используют автоматический подсчет ссылок (ARC) для управления пространством в памяти.
 
 ARC - это система управления памятью, которая отслеживает количество ссылок на данный объект. Когда больше нет ссылок на объект, система знает, что объект больше не нужен и может быть удален из памяти. Чтобы глубже погрузиться в работу автоматического подсчета ссылок (ARC), обратитесь к документации на Swift.org.
 
 Наиболее частым виновником утечек памяти в iOS является цикл сохранения. Цикл сохранения предотвращает освобождение объекта даже после освобождения его создателя. Вот краткий пример:
 */

fileprivate class Dog {
    var name: String
    var owner: Person?

    init(name: String) {
        self.name = name
    }
}

fileprivate class Person {
    var name: String
    var dog: Dog?

    init(name: String) {
        self.name = name
    }
}

fileprivate func test() {
    let myles = Dog(name: "MyLes")
    let tim = Person(name: "Tim")
    myles.owner = tim
    tim.dog = myles
}

/*В этом примере оба объекта содержат ссылки друг на друга. Таким образом, даже после того, как их создатель был освобожден, оба объекта останутся в памяти, потому что их счетчики ссылок все еще больше нуля.
 
 Решением этой проблемы является слабая ссылка, которая не увеличивает счетчик объекта и, следовательно, не влияет на возможность освобождения объекта. Вот обновленная версия приведенного выше примера, которая не вызывает цикл сохранения:*/

fileprivate class DogWeak {
    var name: String
    weak var owner: PersonWeak?

    init(name: String) {
        self.name = name
    }
}


fileprivate class PersonWeak {
    var name: String
    weak var dog: DogWeak?

    init(name: String) {
        self.name = name
    }
}

fileprivate func test2() {
    let myles = DogWeak(name: "MyLes")
    let tim = PersonWeak(name: "Tim")
    myles.owner = tim
    tim.dog = myles
}

/*Хотя циклы сохранения могут происходить между любыми объектами, я обнаружил, что наиболее частое вхождение в iOS - это утечка экземпляров UIViewController, учитывая длинный список обязанностей, делегированных ему в типичном приложении для iOS.
 
 Асинхронные задачи, такие как сетевые запросы, вызовы базы данных, обработка изображений и т. Д., Являются легкими кандидатами на непреднамеренные циклы сохранения, учитывая, что их интерфейсы обычно включают замыкание. Вот пример контроллера представления, который имеет цикл:*/

fileprivate class Worker {
    func performLongRunningTask(_ completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completion()
        }
    }
}


class ViewControllerA: UIViewController {
    /*ViewControllerA имеет ссылку на объект Worker, который выполняет задачу, выполнение которой занимает некоторое время. В результате рабочий объект использует замыкание, чтобы уведомить вызов о его завершении.*/
    private let worker = Worker()
    private var isTaskFinished = false

    override func viewDidLoad() {
        super.viewDidLoad()
        worker.performLongRunningTask {
            /* В этом примере ViewControllerA неявно создает сильную ссылку из Worker на ViewControllerA, ссылаясь на self внутри замыкания, передаваемого Worker в качестве параметра в функции executeLongRunningTask.*/
            self.markTaskFinished()
        }
    }

    func markTaskFinished() {
        isTaskFinished = true
    }
}

class ViewControllerB: UIViewController {

    private let worker = Worker()
    private var isTaskFinished = false

    override func viewDidLoad() {
        super.viewDidLoad()
        /*В этом примере ViewControllerB все еще ссылается на себя внутри замыкания, переданного Worker, но он объявил ссылку слабой, добавив [слабый self] к параметрам замыкания. Этот подход успешно избегает введения цикла сохранения, если ViewControllerB отклонен до того, как Worker завершил свою задачу.*/
        worker.performLongRunningTask { [weak self] in
            self?.markTaskFinished()
        }
    }

    func markTaskFinished() {
        isTaskFinished = true
    }
}

/*При разработке интерфейсов, для которых требуются ссылки, например Worker в этом примере, важно использовать эмпатию и подумать о том, как другие инженеры будут использовать ваш код.
 
 Взаимодействие с замыканиями легко, но создает удобную возможность ввести циклы сохранения. Ответственность за избежание цикла сохранения теперь ложится на инженера, взаимодействующего с Worker, который, возможно, не является инженером, написавшим код для Worker, и может не иметь четкого понимания циклов сохранения.
 
 Эмпатия является ключевой здесь, и мы можем использовать общий шаблон проектирования, чтобы снять эту ответственность с инженера, взаимодействующего с работником. Давайте посмотрим на этот пример:*/

fileprivate protocol WorkerDelegate: class {
    func taskDidComplete()
}

fileprivate class Worker2 {
    /*Эмпатия является ключевой здесь, и мы можем использовать общий шаблон проектирования, чтобы снять эту ответственность с инженера, взаимодействующего с работником. Давайте посмотрим на этот пример:*/
    weak var delegate: WorkerDelegate?

    func performLongRunningTask() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.delegate?.taskDidComplete()
        }
    }
}

class ViewControllerC: UIViewController {
    
    private let worker = Worker2()
    private var isTaskFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worker.delegate = self
        worker.performLongRunningTask()
    }
    
    func markTaskFinished() {
        isTaskFinished = true
    }
}

extension ViewControllerC: WorkerDelegate {
    func taskDidComplete() {
        markTaskFinished()
    }
}
