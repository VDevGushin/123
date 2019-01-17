//
//  Observer.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 17/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Паттерн "Наблюдатель" (Observer) представляет поведенческий шаблон проектирования, который использует отношение "один ко многим". В этом отношении есть один наблюдаемый объект и множество наблюдателей. И при изменении наблюдаемого объекта автоматически происходит оповещение всех наблюдателей.
 
 Данный паттерн еще называют Publisher-Subscriber (издатель-подписчик), поскольку отношения издателя и подписчиков характеризуют действие данного паттерна: подписчики подписываются email-рассылку определенного сайта. Сайт-издатель с помощью email-рассылки уведомляет всех подписчиков о изменениях. А подписчики получают изменения и производят определенные действия: могут зайти на сайт, могут проигнорировать уведомления и т.д.
 
 Когда использовать паттерн Наблюдатель?
    1)Когда система состоит из множества классов, объекты которых должны находиться в согласованных состояниях
 
    2)Когда общая схема взаимодействия объектов предполагает две стороны: одна рассылает сообщения и является главным, другая получает сообщения и реагирует на них. Отделение логики обеих сторон позволяет их рассматривать независимо и использовать отдельно друга от друга.
 
    3)Когда существует один объект, рассылающий сообщения, и множество подписчиков, которые получают сообщения. При этом точное число подписчиков заранее неизвестно и процессе работы программы может изменяться.
 */

// Формальное определение

//представляет наблюдаемый объект. Определяет три метода: AddObserver() (для добавления наблюдателя), RemoveObserver() (удаление набюдателя) и NotifyObservers() (уведомление наблюдателей)
fileprivate protocol Observable {
    func addObserver(observer: Observer)
    func removeObserver(observer: Observer)
    func notifyObserver()
}

//конкретная реализация интерфейса IObservable. Определяет коллекцию объектов наблюдателей.
fileprivate class ConcreteObservable: Observable {
    private var list = [Observer]()

    func addObserver(observer: Observer) {
        self.list.append(observer)
    }

    func removeObserver(observer: Observer) {
        self.list.removeAll {
            $0.id == observer.id
        }
    }

    func notifyObserver() {
        self.list.forEach {
            $0.update()
        }
    }
}

//представляет наблюдателя, который подписывается на все уведомления наблюдаемого объекта. Определяет метод Update(), который вызывается наблюдаемым объектом для уведомления наблюдателя.
fileprivate protocol Observer {
    var id: Int { get set }
    func update()
}

//конкретная реализация интерфейса IObserver.
fileprivate class ConcreteObserver: Observer {
    var id = 1
    func update() {
        print("update")
    }
}

/*
 При этом наблюдаемому объекту не надо ничего знать о наблюдателе кроме того, что тот реализует метод Update(). С помощью отношения агрегации реализуется слабосвязанность обоих компонентов. Изменения в наблюдаемом объекте не виляют на наблюдателя и наоборот.
 
 В определенный момент наблюдатель может прекратить наблюдение. И после этого оба объекта - наблюдатель и наблюдаемый могут продолжать существовать в системе независимо друг от друга.
 
 Рассмотрим реальный пример применения шаблона. Допустим, у нас есть биржа, где проходят торги, и есть брокеры и банки, которые следят за поступающей информацией и в зависимости от поступившей информации производят определенные действия:
 */

fileprivate protocol IObserver {
    var id: Int { get }
    func update(object: Any)
}

fileprivate protocol IObservable {
    func registerObserver(o: IObserver)
    func removeObserver(o: IObserver)
    func notifyObservers()
}

fileprivate struct StockInfo {
    var usd: Int
    var euro: Int
}

fileprivate class Stock: IObservable {
    var sInfo: StockInfo = StockInfo(usd: 0, euro: 0)
    private var observers = [IObserver]()

    func registerObserver(o: IObserver) {
        self.observers.append(o)
    }

    func removeObserver(o: IObserver) {
        self.observers.removeAll {
            $0.id == o.id
        }
    }

    func notifyObservers() {
        self.observers.forEach {
            $0.update(object: sInfo)
        }
    }

    func market() {
        let rand = arc4random()
        sInfo.euro = Int(rand)
        sInfo.usd = Int(rand)
        self.notifyObservers()
    }
}

fileprivate class Broker: IObserver {
    var id: Int
    let stock: IObservable
    init(stock: IObservable) {
        self.stock = stock
        self.id = 1
        stock.removeObserver(o: self)
    }

    func update(object: Any) {

    }
}

fileprivate class Bank: IObserver {
    var id: Int
    let stock: IObservable
    init(stock: IObservable) {
        self.stock = stock
        self.id = 1
        stock.removeObserver(o: self)
    }

    func update(object: Any) {

    }
}

