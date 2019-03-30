//
//  Using errors as control flow in Swift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 21/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*То, как мы управляем потоком управления в приложениях и системах, над которыми мы работаем, может оказать огромное влияние на все: от скорости выполнения нашего кода до простоты его отладки. Поток управления нашего кода - это, по сути, порядок, в котором выполняются наши различные функции и операторы, и какие пути кода в итоге вводятся.
 
 В то время как Swift предлагает ряд инструментов для определения потока управления - таких как операторы вроде if, else и while и конструкции как опциональные - на этой неделе давайте посмотрим, как мы можем использовать встроенную в Swift модель обработки ошибок и обработки ошибок, чтобы сделать наш поток управления проще в управлении.*/

// MARK: -Throwing away optionals

/*Необязательные функции, хотя они являются важной языковой функцией и отличным способом моделирования данных, которые могут отсутствовать на законных основаниях, часто могут стать источником шаблонного примера, когда речь заходит о потоке управления в рамках данной функции.
 
 Здесь мы написали функцию, которая позволяет нам загружать изображение из пакета нашего приложения, а затем подкрашивать и изменять его размер. Поскольку каждая из этих операций в настоящее время возвращает необязательное изображение, мы получаем несколько защитных операторов и точек, из которых наша функция может выйти:*/

fileprivate func loadImage(named name: String,
                           tintedWith color: UIColor,
                           resizedTo size: CGSize) -> UIImage? {
    guard let baseImage = UIImage(named: name) else { return nil }

    guard let tintedImage = tint(baseImage, with: color) else {
        return nil
    }

    return resize(tintedImage, to: size)
}

fileprivate func tint(_ image: UIImage, with: UIColor) -> UIImage? { return nil }
fileprivate func resize(_ image: UIImage, to: CGSize) -> UIImage? { return nil }

/*Проблема, с которой мы сталкиваемся выше, заключается в том, что мы, по сути, используем нулевые значения для устранения ошибок во время выполнения, что имеет и обратную сторону, заставляя нас развертывать результат каждой операции, а также скрывает основную причину возникновения ошибки. на первом месте.
 
 Давайте посмотрим, как мы могли бы решить обе эти проблемы путем рефакторинга нашего потока управления вместо использования бросающих функций и ошибок. Мы начнем с определения перечисления, содержащего регистры для каждой ошибки, которая может возникнуть в нашем коде обработки изображений - выглядит примерно так:*/

fileprivate enum ImageError: Error {
    case missing
    case failedToCreateContext
    case failedToRenderImage
}

fileprivate func loadImage(named name: String,
                           tintedWith color: UIColor,
                           resizedTo size: CGSize)throws -> UIImage {
    guard let image = UIImage(named: name) else {
        throw ImageError.missing
    }
    return image
}

// MARK: - Validating input
/*Далее, давайте посмотрим, как мы можем улучшить наш поток управления, используя ошибки при выполнении проверки ввода. Несмотря на то, что Swift имеет действительно продвинутую и мощную систему типов, он не всегда может гарантировать, что наши функции получат корректный ввод - иногда проверка времени выполнения является нашей единственной возможностью.
 
 Давайте рассмотрим другой пример, в котором мы проверяем выбранные учетные данные пользователя при регистрации новой учетной записи. Как и прежде, наш код в настоящее время использует защитные операторы для каждого правила проверки и выводит сообщение об ошибке в случае сбоя, например:*/

//Простой пример валидации, который мы будем исправлять
fileprivate struct AuthService {
    func signUp(with: Credentials, then handler: (Bool) -> Void) {

    }
}

fileprivate struct Credentials {
    var username: String
    var password: String
}

fileprivate func signUpIfPossible(with credentials: Credentials, service: AuthService) {
    var error = ""

    guard credentials.username.count >= 3 else {
        error = "Username must contain min 3 characters"
        return
    }

    guard credentials.password.count >= 7 else {
        error = "Password must contain min 7 characters"
        return
    }

    service.signUp(with: credentials) { result in
    }
    dump(error)
}

/*Несмотря на то, что мы проверяем только две части данных выше, наша логика проверки может в конечном итоге расти гораздо быстрее, чем мы могли бы ожидать. Наличие такой логики в сочетании с нашим UI-кодом (обычно в контроллере представления) также значительно усложняет тестирование - поэтому давайте посмотрим, сможем ли мы сделать некоторую развязку, а также улучшить наш поток управления в процессе.
 
 В идеале мы хотели бы, чтобы наш код проверки был автономным. Таким образом, он может работать и тестироваться изолированно, а также легко использоваться повторно в нашей кодовой базе и за ее пределами. Чтобы это произошло, давайте начнем с создания выделенного типа для всей логики валидации. Мы назовем его Validator и сделаем его простой структурой, которая содержит закрытие проверки для данного типа значения:*/

fileprivate struct Validator<T> {
    let closure: (T) throws -> Void
}

/*Используя вышеизложенное, мы сможем создать валидаторы, которые выдают ошибку, когда значение не прошло валидацию. Однако необходимость всегда определять новый тип ошибки для каждого процесса проверки может снова генерировать ненужный шаблон (особенно если все, что мы хотим сделать с ошибкой, это показать ее пользователю) - поэтому давайте также представим функцию, которая позволяет нам писать проверку логика, просто передав условие Bool и сообщение для отображения пользователю в случае сбоя:*/

fileprivate struct ValidationError: LocalizedError {
    let message: String
    var errorDiscription: String? {
        return message
    }
}

fileprivate extension Validator where T == String {
    private static func validateError(_ condition: @autoclosure () -> Bool,
                                     errorMessage: @autoclosure () -> String) throws {
        
        guard condition() else {
            let message = errorMessage()
            throw ValidationError(message: message)
        }
    }
    
    //Проверка пароля
    static var password: Validator {
        return Validator { string in
            try validateError(
                string.count >= 7,
                errorMessage: "Password must contain min 7 characters"
            )

            try validateError(
                string.lowercased() != string,
                errorMessage: "Password must contain an uppercased character"
            )

            try validateError(
                string.uppercased() != string,
                errorMessage: "Password must contain a lowercased character"
            )
        }
    }
    
    //Проверка юзера
    static var username: Validator {
        return Validator { string in
            try validateError(
                string.count >= 7,
                errorMessage: "Username must contain min 7 characters"
            )
        }
    }
}

fileprivate func validate<T>(_ value: T, using validator: Validator<T>) throws {
    try validator.closure(value)
}

// Финальное исполнение
fileprivate func signUpIfPossible(with credentials: Credentials) throws {
    try validate(credentials.password, using: .password)
}
