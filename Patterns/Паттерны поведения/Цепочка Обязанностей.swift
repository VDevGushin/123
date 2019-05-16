//
//  Цепочка Обязанностей.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 25/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Цепочка Обязанностей (Chain of responsibility) - поведенческий шаблон проектирования, который позволяет избежать жесткой привязки отправителя запроса к получателю, позволяя нескольким объектам обработать запрос. Все возможные обработчики запроса образуют цепочку, а сам запрос перемещается по этой цепочке, пока один из ее объектов не обработает запрос. Каждый объект при получении запроса выбирает, либо обработать запрос, либо передать выполнение запроса следующему по цепочке.
 
 Когда применяется цепочка обязанностей?
    1) Когда имеется более одного объекта, который может обработать определенный запрос
    2) Когда надо передать запрос на выполнение одному из нескольких объект, точно не определяя, какому именно объекту
    3) Когда набор объектов задается динамически*/

//Handler: определяет интерфейс для обработки запроса. Также может определять ссылку на следующий обработчик запроса
fileprivate func main() {
    var h1 = ConcreteHandler1()
    let h2 = ConcreteHandler2()
    h1.successor = h2
    h1.handleRequest(condition: 2)
}

fileprivate protocol IHandler: class {
    var successor: IHandler? { get set }
    func handleRequest(condition: Int)
}

fileprivate class ConcreteHandler1: IHandler {
    weak var successor: IHandler?

    func handleRequest(condition: Int) {
        if condition == 1 {
            print("concrete handler")
            return
        }

        if let successor = self.successor {
            successor.handleRequest(condition: condition)
        }
    }
}

fileprivate class ConcreteHandler2: IHandler {
    weak var successor: IHandler?

    func handleRequest(condition: Int) {
        if condition == 2 {
            print("concrete handler")
            return
        }

        if let successor = self.successor {
            successor.handleRequest(condition: condition)
        }
    }
}

/*Рассмотрим конкретный пример. Допустим, необходимо послать человеку определенную сумму денег. Однако мы точно не знаем, какой способ отправки может использоваться: банковский перевод, системы перевода типа WesternUnion и Unistream или система онлайн-платежей PayPal. Нам просто надо внести сумму, выбрать человека и нажать на кнопку. Подобная система может использоваться на сайтах фриланса, где все отношения между исполнителями и заказчиками происходят опосредованно через функции системы и где не надо знать точные данные получателя.*/

func testChainOfResponsibility() {
    let receiver = Receiver(bankTransfer: false, moneyTransfer: true, payPalTransfer: false)
    let bankPaymentHandler = BankPaymentHandler()
    let moneyPaymentHnadler = MoneyPaymentHandler()
    let paypalPaymentHandler = PayPalPaymentHandler()

    bankPaymentHandler.successor = paypalPaymentHandler
    paypalPaymentHandler.successor = moneyPaymentHnadler
    bankPaymentHandler.handle(receiver: receiver)
}

struct Receiver {
    let bankTransfer: Bool
    let moneyTransfer: Bool
    let payPalTransfer: Bool
}

protocol PaymentHandler: class {
    var successor: PaymentHandler? { get set }
    func handle(receiver: Receiver)
}

class BankPaymentHandler: PaymentHandler {
    weak var successor: PaymentHandler?

    func handle(receiver: Receiver) {
        if receiver.bankTransfer {
            print("банковский перевод")
            return
        }
        if let successor = successor {
            successor.handle(receiver: receiver)
        }
    }
}

class PayPalPaymentHandler: PaymentHandler {
    weak var successor: PaymentHandler?

    func handle(receiver: Receiver) {
        if receiver.payPalTransfer {
            print("Выполняем перевод через PayPal")
            return
        }
        if let successor = successor {
            successor.handle(receiver: receiver)
        }
    }
}

class MoneyPaymentHandler: PaymentHandler {
    weak var successor: PaymentHandler?

    func handle(receiver: Receiver) {
        if receiver.moneyTransfer {
            print("Выполняем перевод через системы денежных переводов")
            return
        }
        if let successor = successor {
            successor.handle(receiver: receiver)
        }
    }
}
