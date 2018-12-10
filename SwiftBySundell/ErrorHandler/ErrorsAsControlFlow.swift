//
//  ErrorsAsControlFlow.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 10/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate func loadImage(named name: String, tintedWith color: UIColor, resizeTo size: CGSize) -> UIImage? {
    guard let baseImage = UIImage(named: name) else { return nil }

    guard let tintedImage = tint(baseImage, with: color) else { return nil }

    return resize(tintedImage, to: size)
}

fileprivate func resize(_ image: UIImage, to: CGSize) -> UIImage? { return nil }
fileprivate func tint(_ image: UIImage, with: UIColor) -> UIImage? { return nil }

//Попробуем реализовать данную функцию с помощью ошибок
fileprivate enum ImageError: Error {
    case missing
    case failedToCreateContext
    case failedToRenderImage
}

fileprivate func loadImage(named name: String) throws -> UIImage {
    guard let image = UIImage(named: name) else {
        throw ImageError.missing
    }
    return image
}

// MARK: - Validating input
fileprivate struct Credentials {
    let username: String
    let password: String
}

//Использоывание плохого варината валидации
fileprivate func signUpIfPossible(with credentials: Credentials) {
    guard credentials.username.count >= 3 else {
        let _ = "Username must contain min 3 characters"
        return
    }

    guard credentials.password.count >= 7 else {
        let _ = "Password must contain min 7 characters"
        return
    }
    //Запуск сервиса
    //...
}

//using Validator
fileprivate struct ValidatorMethods{
    
}

fileprivate struct Validator<Value> {
    let closure: (Value) throws -> Void
}

extension Validator where Value == String {
    static var password: Validator {
        return Validator { string in
            try validate(
                string.count >= 7,
                errorMessage: "Password must contain min 7 characters"
            )

            try validate(
                string.lowercased() != string,
                errorMessage: "Password must contain an uppercased character"
            )

            try validate(
                string.uppercased() != string,
                errorMessage: "Password must contain a lowercased character"
            )
        }
    }

    static var userName: Validator {
        return Validator { string in
            try validate(
                string.count >= 7,
                errorMessage: "User must contain min 7 characters"
            )
        }
    }
}

fileprivate struct ValidationError: LocalizedError {
    let message: String
    var errorDescription: String? { return message }
}

fileprivate func validate(_ condition: @autoclosure () -> Bool, errorMessage messageExpression: @autoclosure () -> String) throws {
    guard condition() else {
        let message = messageExpression()
        throw ValidationError(message: message)
    }
}

fileprivate func validate<T>(_ value: T, using validator: Validator<T>) throws {
    try validator.closure(value)
}

fileprivate func signUpIfPossibleWithValidator(with credentials: Credentials) throws {
    try validate(credentials.username, using: .userName)
    try validate(credentials.password, using: .password)
    //logic
}
