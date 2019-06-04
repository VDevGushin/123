//
//  The power of key paths in Swift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate func test() {
    let message = "Hello world!"

    switch message {
    case "Hello": print("hello")
    case "World": print("world")
    case "Hello World!": print("Hello World!")
    default: break
    }
}

/*Как вы понимаете, этот код выведет сообщение «Hello World!» В консоли. В большинстве случаев сопоставление с образцом работает как проверка на равенство, за исключением диапазонов, где он относится к методу «содержит» типа Range.
 
 Итак, вопрос «Как это действительно работает?». За операцией сопоставления с образцом Swift использует оператор ~ =, который перегружен для большинства стандартных типов. При использовании Pattern Matching Swift ищет оператор ~ = для текущих типов. Вот пример того, как оператор ~ = выглядит для типа String.*/

func ~= (pattern: String, value: String) -> Bool {
    return pattern == value
}
/*Хорошей новостью является то, что мы можем легко перегрузить оператор ~ =, чтобы изменить это поведение. Например, в приведенном ниже листинге кода мы меняем реализацию на собственную, где вместо проверки на равенство выполняется поиск соответствия, и теперь вы увидите сообщение «Hello» в консоли.d*/

fileprivate struct User {
    let firstName: String
    let secondName: String
    let age: Int
}

extension User {
    static func ~= (range: ClosedRange<Int>, user: User) -> Bool {
        return range.contains(user.age)
    }
}

fileprivate func test2() {
    let user = User(firstName: "123", secondName: "32132", age: 27)
    switch user {
    case 21...30: print("The user age is between 21 and 30")
    case 31...40: print("The user age is between 31 and 40")
    default: break
    }
}

/*Здесь мы имеем простую структуру User, которая содержит поля имени, имени и возраста. Я хочу использовать экземпляры структуры пользователя в выражениях switch для соответствия возрастному диапазону моих пользователей. Пожалуйста, обратите внимание на порядок параметров в ~ = function. Первый описывает значение регистра, где второй - это значение, используемое после ключевого слова switch. Вывод консоли в данном случае: «Возраст пользователя от 20 до 30».
 
 Еще одним хорошим вариантом для перегрузки оператора сопоставления с образцом могут быть регулярные выражения. Я хочу сопоставить текст с несколькими шаблонами регулярных выражений. Давайте погрузимся в код.*/
fileprivate struct Regex {
    let pattern: String

    static let email = Regex(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    static let phone = Regex(pattern: "([+]?1+[-]?)?+([(]?+([0-9]{3})?+[)]?)?+[-]?+[0-9]{3}+[-]?+[0-9]{4}")

    static func ~= (regex: Regex, text: String) -> Bool {
        return text.range(of: regex.pattern, options: .regularExpression) != nil
    }
}
/*Здесь у нас есть структура Regex, которая имеет только одно поле, и это строка шаблона. Мы также реализуем статические константы электронной почты и телефона с предопределенными регулярными выражениями. Далее мы перегружаем оператор ~ =, в этом случае он сопоставляет текст с нашей структурой Regex с помощью метода range из строкового типа. Это все, что нам нужно, чтобы использовать наш тип регулярных выражений для сопоставления с образцом. Вот пример использования.*/
fileprivate func test3() {
    let email = "cmecid@gmail.com"

    switch email {
    case Regex.email: print("email")
    case Regex.phone: print("phone")
    default: print("default")
    }
}
