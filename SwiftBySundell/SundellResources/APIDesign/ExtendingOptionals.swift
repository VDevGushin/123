//
//  ExtendingOptionals.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 01/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Converting nil into errors
/*При работе с дополнительными значениями очень часто требуется преобразовать значение nil в правильную ошибку Swift, которая затем может быть передана и отображена для пользователя. Например, здесь мы готовим изображение для загрузки на наш сервер с помощью ряда операций. Поскольку каждая операция может возвращать nil, мы разворачиваем результат каждого шага, выдавая ошибку, если встретился nil - вот так:*/
fileprivate enum MyError: Error {
    case preparationFailed
}

fileprivate class FileUploader {
    func prepareImageForUpload(_ image: UIImage)throws -> UIImage {
        guard let watermarked = self.watermark(image) else {
            throw MyError.preparationFailed
        }

        guard let encrypted = self.encrypt(watermarked) else {
            throw MyError.preparationFailed
        }

        let _ = try self.encrypt(watermarked).orThrow(MyError.preparationFailed)
        return encrypted
    }

    private func encrypt(_ image: UIImage) -> UIImage? {
        return nil
    }

    private func watermark(_ image: UIImage) -> UIImage? {
        return nil
    }
}

/*Приведенный выше код работает, но давайте посмотрим, сможем ли мы использовать возможности расширений, чтобы сделать его немного более кратким. Во-первых, давайте создадим расширение для типа Optional enum, которое позволит нам либо вернуть его упакованное значение, либо выдать ошибку в случае, если оно содержит nil, например:*/
fileprivate extension Optional {
    func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else { throw errorExpression() }
        return value
    }
}

// MARK: - Expressive checks
/*Другим распространенным сценарием при работе с опционами является желание выполнить какую-то проверку развернутого значения. Например, при реализации пользовательского интерфейса формы нам может потребоваться изменить цвет границы каждого текстового поля при каждом изменении его текста - в зависимости от того, является ли эта строка в настоящее время пустой:*/
fileprivate extension FileUploader {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderColor = UIColor.green.cgColor
        }
    }
}

fileprivate extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

fileprivate extension FileUploader {
    @objc func textFieldDidChange1(_ textField: UITextField) {
        if textField.text.isNilOrEmpty {
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderColor = UIColor.green.cgColor
        }
    }
}

// MARK: - Matching against a predicate
/*
 Далее, давайте посмотрим, как мы можем добавить возможности сопоставления к опциональным. Так же, как мы ранее проверяли, были ли коллекции пустыми, также часто требуется сопоставлять необязательные значения с более настраиваемым выражением, пока необязательное развертывается.
 Например, здесь мы разворачиваем текст строки поиска, а затем проверяем, что он содержит не менее 3 символов, прежде чем выполнять поиск:
 */

fileprivate extension FileUploader {
    @objc func makeRequest(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.count > 2 else {
            return
        }
        performSearch(with: query)

        //OR
        searchBar.text.matching {
            $0.count > 2
        }.map(performSearch)
    }

    private func performSearch(with: String) { }
}

fileprivate extension Optional {
    func matching(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self else { return nil }

        guard predicate(value) else { return nil }
        return value
    }
}

// MARK: - Assigning reusable views
/*Наконец, давайте посмотрим, как мы можем расширить тип Optional, чтобы сделать работу с повторно используемыми представлениями более приятной. Распространенный шаблон в каркасах пользовательского интерфейса Apple - представления, предоставляющие определенные «слоты», в которые мы, как пользователь API, можем вставлять собственные настраиваемые подпредставления. Например, UITableViewCell предоставляет свойство accessoryView, которое позволяет нам размещать любое представление, которое мы хотим, на заднем крае ячейки, что очень удобно при создании пользовательских списков.
 
 Однако, так как эти слоты должны поддерживать любой вид представления, тип, с которым мы имеем дело, чаще всего является Необязательным <UIView> - это означает, что нам почти всегда приходится выполнять приведение типов для преобразования значения такого свойства в наше собственное представление типа, что приводит к множеству танцев, которые выглядят примерно так:*/

fileprivate class TodoItemStatusView: UIView { }

fileprivate func test(cell: UITableViewCell) {
    if let statusView = cell.accessoryView as? TodoItemStatusView {
        dump(statusView)
    } else {
        let statusView = TodoItemStatusView(frame: .zero)
        cell.accessoryView = statusView
    }

    let statusView = cell.accessoryView.get(orSet: TodoItemStatusView())
    dump(statusView)
}

/*Это еще одна ситуация, в которой расширение на Optional может оказаться очень полезным. Давайте напишем расширение для всех опций, которые обертывают UIView, и снова используем мощь @autoclosure, чтобы позволить нам передать выражение, создающее новое представление, если это необходимо, которое используется только в том случае, если у нас нет существующего:*/
fileprivate extension Optional where Wrapped == UIView {
    mutating func get<T: UIView>(orSet expression: @autoclosure () -> T) -> T {
        guard let view = self as? T else {
            let newView = expression()
            self = newView
            return newView
        }
        return view
    }
}
