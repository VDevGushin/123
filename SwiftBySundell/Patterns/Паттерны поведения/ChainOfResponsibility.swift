//
//  ChainOfResponsibility.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Цепочка Обязанностей (Chain of responsibility) - поведенческий шаблон проектирования, который позволяет избежать жесткой привязки отправителя запроса к получателю, позволяя нескольким объектам обработать запрос. Все возможные обработчики запроса образуют цепочку, а сам запрос перемещается по этой цепочке, пока один из ее объектов не обработает запрос. Каждый объект при получении запроса выбирает, либо обработать запрос, либо передать выполнение запроса следующему по цепочке.
 
 Когда применяется цепочка обязанностей?
    1)Когда имеется более одного объекта, который может обработать определенный запрос
    2)Когда надо передать запрос на выполнение одному из нескольких объект, точно не определяя, какому именно объекту
    3)Когда набор объектов задается динамически
 */
//Формальное определение:

//определяет интерфейс для обработки запроса. Также может определять ссылку на следующий обработчик запроса
fileprivate protocol HandlerProtocol {
    var successor: HandlerProtocol? { get set }
    func handleRequest(condition: Int)
}

/*ConcreteHandler1 и ConcreteHandler2: конкретные обработчики, которые реализуют функционал для обработки запроса. При невозможности обработки и наличия ссылки на следующий обработчик, передают запрос этому обработчику
 
 В данном случае для простоты примера в качестве параметра передается некоторое число, и в зависимости от значения данного числа обработчики и принимают решения об обработке запроса.*/
fileprivate class ConcreteHandler1: HandlerProtocol {
    var successor: HandlerProtocol?

    func handleRequest(condition: Int) {
        if condition == 1 {
            //обработка
            return
        }
        if let successor = self.successor {
            successor.handleRequest(condition: condition)
        }
    }
}

fileprivate class ConcreteHandler2: HandlerProtocol {
    var successor: HandlerProtocol?

    func handleRequest(condition: Int) {
        if condition == 2 {
            //обработка
            return
        }
        if let successor = self.successor {
            successor.handleRequest(condition: condition)
        }
    }
}

//Client: отправляет запрос объекту Handler
fileprivate class Client {
    func main() {
        //Client -> ConcreteHandler1 -> ConcreteHandler2
        let h1 = ConcreteHandler1()
        let h2 = ConcreteHandler2()
        h1.successor = h2
        h1.handleRequest(condition: 2)
    }
}
//В то же время у паттерна есть недостаток: никто не гарантирует, что запрос в конечном счете будет обработан. Если необходимого обработчика в цепочки не оказалось, то запрос просто выходит из цепочки и остается необработанным.

/*
 Рассмотрим конкретный пример. Допустим, необходимо послать человеку определенную сумму денег. Однако мы точно не знаем, какой способ отправки может использоваться: банковский перевод, системы перевода типа WesternUnion и Unistream или система онлайн-платежей PayPal. Нам просто надо внести сумму, выбрать человека и нажать на кнопку. Подобная система может использоваться на сайтах фриланса, где все отношения между исполнителями и заказчиками происходят опосредованно через функции системы и где не надо знать точные данные получателя.
 */

fileprivate struct Receiver {
    // банковские переводы
    var bankTransfer: Bool
    // денежные переводы - WesternUnion, Unistream
    var moneyTransfer: Bool
    // перевод через PayPal
    var payPalTransfer: Bool
}

fileprivate protocol PaymentHandler {
    var successor: PaymentHandler? { get set }
    func handle(receiver: Receiver)
}

fileprivate class BankPaymentHandler: PaymentHandler {
    var successor: PaymentHandler?

    func handle(receiver: Receiver) {
        if receiver.bankTransfer {
            print("Выполняем банковский перевод")
            return
        }
        if let successor = self.successor {
            successor.handle(receiver: receiver)
        }
    }
}

fileprivate class PayPalPaymentHandler: PaymentHandler {
    var successor: PaymentHandler?

    func handle(receiver: Receiver) {
        if receiver.payPalTransfer {
            print("Выполняем перевод через PayPal")
            return
        }
        if let successor = self.successor {
            successor.handle(receiver: receiver)
        }
    }
}

fileprivate class MoneyPaymentHandler: PaymentHandler {
    var successor: PaymentHandler?

    func handle(receiver: Receiver) {
        if receiver.moneyTransfer {
            print("Выполняем перевод через системы денежных переводов")
            return
        }
        if let successor = self.successor {
            successor.handle(receiver: receiver)
        }
    }
}

fileprivate class Program {
    func main() {
        let receiver = Receiver(bankTransfer: true, moneyTransfer: false, payPalTransfer: false)
        let bankPaymentHandler = BankPaymentHandler()
        let moneyPaymentHnadler = MoneyPaymentHandler()
        let paypalPaymentHandler = PayPalPaymentHandler()
        bankPaymentHandler.successor = paypalPaymentHandler
        paypalPaymentHandler.successor = moneyPaymentHnadler
        bankPaymentHandler.handle(receiver: receiver)
    }
}
