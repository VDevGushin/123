//
//  SingleResponsibilityPrinciple.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 26/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
//Принцип единственной обязанности
//У класса должна быть только одна причина для изменения
/*Под обязанностью здесь понимается набор функций, которые выполняют единую задачу. Суть этого принципа заключается в том, что класс должен выполнять одну единственную задачу. Весь функционал класса должен быть целостным, обладать высокой связностью (high cohesion).
 
 Конкретное применение принципа зависит от контекста. В данном случае важно понимать, как изменяется класс. Если класс выполняет несколько различных функций, и они изменяются по отдельности, то это как раз тот случай, когда можно применить принцип единственной обязанности. То есть иными словами, у класса несколько причин для изменения.
 
 Но если же все функции класса, как правило, изменяются вместе и составляют одно функциональное целое, решают одну задачу, то нет смысла применять данный принцип. Рассмотрим применение принципа на примере.
 
 Допустим, нам надо определить класс отчета, по которому мы можем перемещаться по страницам и который можно выводить на печать. На первый взгляд мы могли бы определить следующий класс:*/
fileprivate final class ReportBad {
    var test: String = ""

    func goToFirstPage() {
        print("Переход к первой странице")
    }

    func goToLastPage() {
        print("Переход к последней стрнице")
    }

    func goToPage(number: Int) {
        print("Переход к \(number) стринице")
    }

    func printText() {
        print("Печать отчета")
        print(self.test)
    }
}
/*Первые три метода относятся к навигации по отчету и представляют одно единое функциональное целое. От них отличается метод Print, который производит печать. Что если нам понадобится печатать отчет на консоль или передать его на принтер для физической печати на бумаге? Или вывести в файл? Сохранить в формате html, txt, rtf и т.д.? Очевидно, что мы можем для этого поменять нужным образом метод Print(). Однако это вряд ли затронет остальные методы, которые относятся к навигации страницы.
 
 Также верно и обратное - изменение методов постраничной навигации вряд ли повлияет на возможность вывода текста отчета на принтер или на консоль. Таким образом, у нас здесь прослеживаются две причины для изменения, значит, класс Report обладает двумя обязанностями, и от одной из них этот класс надо освободить.
 
 В этом случае мы могли бы вынести функционал печати в отдельный класс, а потом применить агрегацию:*/

fileprivate protocol Printer {
    func makePrint(text: String)
}

fileprivate final class ConsolePrinter: Printer {
    func makePrint(text: String) {
        print(text)
    }
}

fileprivate final class Report {
    var text: String = ""

    func goToFirstPage() {
        print("Переход к первой странице")
    }

    func goToLastPage() {
        print("Переход к последней стрнице")
    }

    func goToPage(number: Int) {
        print("Переход к \(number) стринице")
    }

    func printText(with printer: Printer) {
        print("Печать отчета")
        printer.makePrint(text: self.text)
    }
}
/*Теперь объект Report получает ссылку на объект IPrinter, который используется для печати, и через метод Print выводится содержимое отчета:*/
fileprivate func testReportWithPrinter() {
    let printer = ConsolePrinter()
    let report = Report()
    report.text = "Hello wolrd"
    report.printText(with: printer)
}

/*Побочным положительным действием является то, что теперь функционал печати инкапсулируется в одном месте, и мы сможем использовать его повторно для объектов других классов, а не только Report.
 
 Однако обязанности в классах не всегда группируются по методам. Вполне возможно, что в одном методе сгруппировано несколько обязанностей. Например:*/

fileprivate struct Phone {
    var model: String
    var price: Int
}

fileprivate struct StreamWriter {
    let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    init() {
        self.init(fileName: "def.txt")
    }

    func writeLine(object: Any) { }
}

fileprivate struct Console {
    func readLine() -> String { return "" }
}

fileprivate enum SolidError: Error {
    case invalidData
}

fileprivate struct MobileStoreBad {
    var phones = [Phone]()

    mutating func process()throws {
        //1 Обязанность ввода
        let console = Console()
        print("Введите модель:")
        let model = console.readLine()
        print("Введите цену:")
        let priceStr = console.readLine()
        /////

        //2 Валидация цены
        guard let price = Int(priceStr) else {
            throw SolidError.invalidData
        }
        /////

        //3 Формирование списка
        //4 Создание телефона
        self.phones.append(Phone(model: model, price: price))
        /////

        //5 Запись в файл
        let streamWriter = StreamWriter()
        streamWriter.writeLine(object: model)
        streamWriter.writeLine(object: price)
        print("Данные успешно обработанны")
    }
}
/*Класс имеет один единственный метод Process, однако этот небольшой метод, содержит в себе как минимум четыре обязанности: ввод данных, их валидация, создание объекта Phone и сохранение. В итоге класс знает абсолютно все: как получать данные, как валидировать, как сохранять. При необходимости в него можно было бы засунуть еще пару обязанностей. Такие классы еще называют "божественными" или "классы-боги", так как они инкапсулируют в себе абсолютно всю функциональность. Подобные классы являются одним из распространенных анти-паттернов, и их применения надо стараться избегать.
 
 Хотя тут довольно немного кода, однако при последующих изменениях метод Process может быть сильно раздут, а функционал усложнен и запутан.
 
 Теперь изменим код класса, инкапсулировав все обязанности в отдельных классах:*/

//1 Обязанность ввода
fileprivate protocol PhoneReader {
    func getInputData() -> [String]
}

fileprivate final class ConsolePhoneReader: PhoneReader {
    func getInputData() -> [String] {
        let console = Console()
        print("Введите модель:")
        let model = console.readLine()
        print("Введите цену:")
        let price = console.readLine()
        return [model, price]
    }
}

//2 Создание телефона
fileprivate protocol PhoneBuilder {
    func createPhone(with data: [String])throws -> Phone
}

fileprivate final class GeneralPhoneBinder: PhoneBuilder {
    func createPhone(with data: [String])throws -> Phone {
        guard data.count >= 2,
            let price = Int(data[1]) else {
                throw SolidError.invalidData
        }

        let model = data[0]
        return Phone(model: model, price: price)
    }
}

//3 Валидация
fileprivate protocol PhoneValidator {
    func isValid(phone: Phone) -> Bool
}

fileprivate final class GeneralPhoneValidator: PhoneValidator {
    func isValid(phone: Phone) -> Bool {
        if phone.model.isEmpty || phone.price <= 0 {
            return false
        }
        return true
    }
}

//4 Сохранение
fileprivate protocol PhoneSaver {
    func save(phone: Phone, fileName: String)
}

fileprivate final class TextPhoneSaver: PhoneSaver {
    func save(phone: Phone, fileName: String) {
        let streamWriter: StreamWriter = .init(fileName: fileName)
        streamWriter.writeLine(object: phone.model)
        streamWriter.writeLine(object: phone.price)
        print("Данные успешно обработанны")
    }
}

fileprivate struct MobileStore {
    var phones = [Phone]()
    private let reader: PhoneReader
    private let bilder: PhoneBuilder
    private let validator: PhoneValidator
    private let saver: PhoneSaver

    mutating func process() {
        let data = reader.getInputData()
        do {
            let phone = try bilder.createPhone(with: data)
            if validator.isValid(phone: phone) {
                self.phones.append(phone)
                saver.save(phone: phone, fileName: "tet.txt")
                print("Данные успешно сохранены")
            }
            throw SolidError.invalidData
        } catch {
            print("Ошибка работы с данными")
        }
    }
}

/*Теперь для каждой обязанности определен свой интерфейс. Конкретные реализации обязанностей устнавливаются в виде интрефейсов в целевом классе.
 
 В то же время кода стало больше, в связи с чем программа усложнилась. И, возможно, подобное усложнение может показаться неоправданным при наличии одного небольшого метода, который необязательно будет изменяться. Однако при модификации стало гораздо проще вводить новый функционал без изменения существующего кода. А все части метода Process, будучи инкапсулированными во внешних классах, теперь не зависят друг от друга и могут изменяться самостоятельно.
 
 Распространенные случаи нарушения принципа SRP
 
 Нередко принцип единственной обязанности нарушает при смешивании в одном классе функциональности разных уровней. Например, класс производит вычисления и выводит их пользователю, то есть соединяет в себя бизнес-логику и работу с пользовательским интерфейсом. Либо класс управляет сохранением/получением данных и выполнением над ними вычислений, что также нежелательно. Класс слеует применять только для одной задачи - либо бизнес-логика, либо вычисления, либо работа с данными.
 
 Другой распространенный случай - наличие в классе или его методах абсолютно несвязанного между собой функционала.  */
