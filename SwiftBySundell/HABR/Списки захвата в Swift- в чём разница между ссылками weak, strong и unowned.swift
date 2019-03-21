//
//  Списки захвата в Swift- в чём разница между ссылками weak, strong и unowned.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 21/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Список «захваченных» значений находится перед списком параметров замыкания и может «захватить» значения из области видимости тремя разными способами: используя ссылки «strong», «weak» или «unowned». Мы часто его используем, главным образом для того, чтобы избежать циклов сильных ссылок («strong reference cycles» aka «retain cycles»).
 Начинающему разработчику бывает сложно принять решение, какой именно применить способ, так что вы можете потратить много времени, выбирая между «strong» и «weak» или между «weak» и «unowned», но, со временем, вы поймёте, что правильный выбор — только один.
 Для начала создадим простой класс:*/

fileprivate class Singer {
    func playSong() {
        print("Shake it off!")
    }
}

//Затем напишем функцию, которая создаёт экземпляр класса Singer и возвращает замыкание, которое вызывает метод playSong() класса Singer:

fileprivate func sing() -> () -> Void {
    let taylor = Singer()

    let singing = {
        taylor.playSong()
        return
    }

    return singing
}

//Наконец, мы можем где угодно вызвать sing(), чтобы получить результат выполнения playSong()
fileprivate func executeSing() {
    let singFunc = sing()
    singFunc()
    //или
    sing()()
}

// MARK: - «Сильный» захват (strong capturing)
/*До тех пор, пока вы явно не указываете способ захвата, Swift использует «сильный» захват. Это означает, что замыкание захватывает используемые внешние значения и никогда не позволит им освободиться.*/

fileprivate func singStrong() -> () -> Void {
    //Константа taylor определена внутри функции, так что при обычных обстоятельствах занимаемое ей место было бы освобождено как только функция закончила свою работу.
    let taylor = Singer()

    let singing = {
        //Однако эта константа используется внутри замыкания, что означает, что Swift автоматически обеспечит её присутствие до тех пор, пока существует само замыкание, даже после окончания работы функции.
        taylor.playSong()
        return
    }
    //Это «сильный» захват в действии. Если бы Swift позволил освободить taylor, то вызов замыкания был бы небезопасен — его метод taylor.playSong() больше невалиден.
    return singing
}

// MARK: - «Слабый» захват (weak capturing)

//Вызов singFunction() больше не приводит к выводу сообщения. Причина этого в том, что taylor существует только внутри sing(), а замыкание, возвращаемое этой функцией, не удерживает taylor «сильно» внутри себя.

fileprivate func singWeak() -> () -> Void {
    let taylor = Singer()

    let singing = { [weak taylor] in
        //«Слабо» захваченные значения не удерживаются замыканием и, таким образом, они могут быть освобождены и установлены в nil.
        taylor?.playSong()
        //taylor!.playSong() - //Это приведёт к принудительной распаковке taylor внутри замыкания, и, соответственно, к фатальной ошибке (распаковка содержимого, содержащего nil)
        return
    }

    return singing
}


//MARK: - «Бесхозный» захват (unowned capturing)

/*Этот код закончится аварийно схожим образом с принудительно развернутым optional, приведенным несколько выше — unowned taylor говорит: «Я знаю наверняка, что taylor будет существовать все время жизни замыкания, так что мне не нужно удерживать его в памяти». На самом деле taylor будет освобождён практически немедленно и этот код закончится аварийно.
 
 Так что используйте unowned крайне осторожно. */
fileprivate func singUnowned() -> () -> Void {
    let taylor = Singer()

    let singing = { [unowned taylor] in
        taylor.playSong()
        return
    }

    return singing
}

// MARK: - Возникновение цикла сильных ссылок, приводящее к утечке памяти
/*Когда сущность A обладает сущностью B и наоборот — у вас ситуация, называемая циклом сильных ссылок («retain cycle»).*/

fileprivate class House {
    var ownerDetails: (() -> Void)?

    func printDetails() {
        print("This is a great house.")
    }

    deinit {
        print("I'm being demolished!")
    }
}

fileprivate class Owner {
    var houseDetails: (() -> Void)?

    func printDetails() {
        print("I own a house.")
    }

    deinit {
        print("I'm dying!")
    }
}

//Теперь создадим экземпляры этих классов внутри блока do. Нам не нужен блок catch, но использование блока do обеспечит уничтожение экземпляров сразу после }

fileprivate func testRetainCycle() {
    print("Creating a house and an owner")

    do {
        let house = House()
        let owner = Owner()
    }

    //В результате будут выведены сообщения: “Creating a house and an owner”, “I’m dying!”, “I'm being demolished!”, затем “Done” – всё работает, как надо.

    print("Done")

    //####################################################################################
    //Теперь создадим цикл сильных ссылок.

    print("Creating a house and an owner")

    do {
        let house = House()
        let owner = Owner()
        house.ownerDetails = owner.printDetails
        owner.houseDetails = house.printDetails
    }
    //Теперь появятся сообщения “Creating a house and an owner”, затем “Done”. Деинициалайзеры не будут вызваны.
    print("Done")

//    Это произошло в результате того, что у дома есть свойство, которое указывает на владельца, а у владельца есть свойство, указывающее на дом. Поэтому ни один из них не может быть безопасно освобождён. В реальной ситуации это приводит к утечкам памяти, которые приводят к снижению производительности и даже к аварийному завершению приложения.
//
//    Чтобы исправить ситуацию, нам нужно создать новое замыкание и использовать «слабый» захват в одном или двух случаях, вот так:
    print("Creating a house and an owner")

    do {
        let house = House()
        let owner = Owner()
        house.ownerDetails = { [weak owner] in owner?.printDetails() }
        owner.houseDetails = { [weak house] in house?.printDetails() }
    }
    /*Нет необходимости объявлять оба значения захваченным, достаточно сделать и в одном месте — это позволит Swift уничтожить оба класса, когда это необходимо.*/
    print("Done")
}

// MARK: - Копирование замыканий и разделение захваченных значений
/*Последний случай, на котором спотыкаются разработчики, это то, каким образом замыкания копируются, потому что захваченные ими данные становятся доступными для всех копий замыкания.
 Рассмотрим пример простого замыкания, которое захватывает целочисленную переменную numberOfLinesLogged, объявленную снаружи замыкания, так что мы можем увеличивать её значение и распечатывать его всякий раз при вызове замыкания:*/

fileprivate func testCopy() {
    var numberOfLinesLogged = 0

    let logger1 = {
        numberOfLinesLogged += 1
        print("Lines logged: \(numberOfLinesLogged)")
    }

    logger1()
    let logger2 = logger1
    logger2()

    //Lines logged: 1
    //Lines logged: 2
    //Lines logged: 3
    //Lines logged: 4

}

