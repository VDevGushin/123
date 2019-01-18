//
//  Command.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 18/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Паттерн "Команда" (Command) позволяет инкапсулировать запрос на выполнение определенного действия в виде отдельного объекта. Этот объект запроса на действие и называется командой. При этом объекты, инициирующие запросы на выполнение действия, отделяются от объектов, которые выполняют это действие.
 
 Команды могут использовать параметры, которые передают ассоциированную с командой информацию. Кроме того, команды могут ставиться в очередь и также могут быть отменены.
 
 Когда использовать команды?
 
    1)Когда надо передавать в качестве параметров определенные действия, вызываемые в ответ на другие действия. То есть когда необходимы функции обратного действия в ответ на определенные действия.
 
    2)Когда необходимо обеспечить выполнение очереди запросов, а также их возможную отмену.
 
    3)Когда надо поддерживать логгирование изменений в результате запросов. Использование логов может помочь восстановить состояние системы - для этого необходимо будет использовать последовательность запротоколированных команд.
 */

//Формальное определение:

//нтерфейс, представляющий команду. Обычно определяет метод Execute() для выполнения действия, а также нередко включает метод Undo(), реализация которого должна заключаться в отмене действия команды
fileprivate protocol Command {
    func execute()
    func undo()
}

//конкретная реализация команды, реализует метод Execute(), в котором вызывается определенный метод, определенный в классе Receiver
fileprivate struct ConcreteCommand: Command {
    let reciever: Receiver

    func execute() {
        self.reciever.operation()
    }

    func undo() { }
}

//получатель команды. Определяет действия, которые должны выполняться в результате запроса.
fileprivate struct Receiver {
    func operation() {
        print("Operation")
    }
}

//Инициатор команды - вызывает команду для выполнения определенного запроса
fileprivate struct Invoker {
    private var command: Command?

    mutating func setCommand(command: Command) {
        self.command = command
    }

    func run() {
        self.command?.execute()
    }

    func cancel() {
        self.command?.undo()
    }
}

//Клиент - создает команду и устанавливает ее получателя с помощью метода SetCommand()
fileprivate struct Client {
    func main() {
        var invoker = Invoker()
        let receiver = Receiver()
        let command = ConcreteCommand(reciever: receiver)
        invoker.setCommand(command: command)
        invoker.run()
    }
}

/*
 Таким образом, инициатор, отправляющий запрос, ничего не знает о получателе, который и будет выполнять команду. Кроме того, если нам потребуется применить какие-то новые команды, мы можем просто унаследовать классы от абстрактного класса Command и реализовать его методы Execute и Undo.
 */

/*
 Самая простая ситуация - надо программно организовать включение и выключение прибора, например, телевизора. Решение данной задачи с помощью команд могло бы выглядеть так:
 
 Итак, в этой программе есть интерфейс команды - ICommand, есть ее реализация в виде класса TVOnCommand, есть инициатор команды - класс Pult, некий прибор - пульт, управляющий телевизором. И есть получатель команды - класс TV, представляющий телевизор. В качестве клиента используется класс Program.
 */

fileprivate protocol ICommand {
    func execute()
    func undo()
}

fileprivate class TV {
    func on() {
        print("Телевизор включен")
    }

    func off() {
        print("Телевизор выключен")
    }
}

fileprivate struct TVCommand: ICommand {
    private let tv: TV
    init(tv: TV) {
        self.tv = tv
    }

    func execute() {
        tv.on()
    }

    func undo() {
        tv.off()
    }
}

fileprivate struct Pult {
    private var command: ICommand?
    mutating func set(command: ICommand) {
        self.command = command
    }

    func pressButton() {
        self.command?.execute()
    }

    func pressUndo() {
        self.command?.undo()
    }
}

/*
 Например, в нашей программе кроме телевизора появилась микроволновка, которой тоже неплохо было бы управлять с помощью одного интерфейса. Для этого достаточно добавить соответствующие классы и установить команду:
 */

fileprivate struct Microwave {
    func startCooking(time: Int) {
        print("Прогреваем еду")
    }
    func stopCooking() {
        print("Еда прогрета")
    }
}

fileprivate struct MicrowaveCommand: ICommand {
    private let microwave: Microwave
    init(microwave: Microwave) {
        self.microwave = microwave
    }

    func execute() {
        self.microwave.startCooking(time: 12)
    }

    func undo() {
        self.microwave.stopCooking()
    }
}


fileprivate class Programm {
    func main() {
        let tv = TV()
        let tvCommand = TVCommand(tv: tv)
        var pult = Pult()
        pult.set(command: tvCommand)

        pult.pressButton()
        pult.pressUndo()

        let microwave = Microwave()
        let microwaveCommnad = MicrowaveCommand(microwave: microwave)
        pult.set(command: microwaveCommnad)

        pult.pressButton()
        pult.pressUndo()
    }
}


//При этом инициатор необязательно указывает на одну команду. Он может управлять множеством команд. Например, на пульте от телевизора есть как кнопка для включения, так и кнопки для регулировки звука:

fileprivate class MyTV {
    func on() {
        print("Телевизор включен!")
    }
    func off() {
        print("Телевизор выключен...")
    }
}

fileprivate class Volume {
    let off = 0
    let hight = 100
    var level: Int

    init() {
        self.level = self.off
    }

    func raiseLevel() {
        if level < self.hight {
            level += 1
        }
        print("Уровень звука \(self.level)")
    }

    func dropLevel() {
        if level > self.off {
            self.level -= 1
        }
        print("Уровень звука \(self.level)")
    }
}

fileprivate class MyTVCommand: ICommand {
    private let myTV: MyTV
    init(myTV: MyTV) {
        self.myTV = myTV
    }

    func execute() {
        self.myTV.on()
    }

    func undo() {
        self.myTV.off()
    }
}

fileprivate class VolumeCommand: ICommand {
    private let volume: Volume
    init(volume: Volume) {
        self.volume = volume
    }

    func execute() {
        self.volume.raiseLevel()
    }

    func undo() {
        self.volume.dropLevel()
    }
}

fileprivate class MultiPult {
    private lazy var buttons: [ICommand?] = []
    private lazy var commandsHistory: [ICommand] = []

    func setCommad(number: Int, command: ICommand) {
        self.buttons[number] = command
    }

    func pressButton(number: Int) {
        if let command = self.buttons[number] {
            command.execute()
            self.commandsHistory.append(command)
        }
    }

    func pressUndoButton() {
        if commandsHistory.count > 0 {
            let undoCommand = commandsHistory.removeLast()
            undoCommand.undo()
        }
    }
}


fileprivate func workWithMultiPult() {
    let myTV = MyTV()
    let volume = Volume()
    let multiPult = MultiPult()

    multiPult.setCommad(number: 0, command: MyTVCommand(myTV: myTV))
    multiPult.setCommad(number: 1, command: VolumeCommand(volume: volume))

    //Включаем телевизор
    multiPult.pressButton(number: 0)
    //Увеличиваем громкость
    multiPult.pressButton(number: 1)
    multiPult.pressButton(number: 1)
    multiPult.pressButton(number: 1)
    //Действия отмены
    multiPult.pressUndoButton()
    multiPult.pressUndoButton()
    multiPult.pressUndoButton()
    multiPult.pressUndoButton()
}
