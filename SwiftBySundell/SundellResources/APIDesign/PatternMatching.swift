//
//  PatternMatching.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*Одним из действительно элегантных аспектов дизайна Swift является то, как ему удается скрыть большую часть своей силы и сложности за гораздо более простыми конструкциями программирования. Возьмите что-то вроде цикла for или оператора switch - на первый взгляд, оба работают в Swift примерно так же, как и в других языках - но ныряйте на несколько уровней глубже, и оказывается, что они гораздо мощнее, чем сначала может показаться, что
 
 Сопоставление с образцом является одним из источников этой дополнительной силы, особенно учитывая то, насколько оно интегрировано во многие различные аспекты языка. На этой неделе давайте рассмотрим некоторые из этих аспектов - и как сопоставление с образцом открывает стили кодирования, которые могут оказаться действительно удобными и довольно элегантными.*/

// MARK: - Iterative patterns
/*Допустим, мы создаем приложение для обмена сообщениями и работаем над функцией, которая перебирает все сообщения в списке и удаляет те, которые были отмечены пользователем. В настоящее время мы реализовали эту итерацию, используя стандартный цикл for с вложенным оператором if, например:*/
fileprivate struct Message {
    var isMarked: Bool
}

fileprivate struct DataBase {
    func delete(_ message: Message) { }
}

fileprivate func deleteMarkedMessages(from messages: [Message], dataBase: DataBase) {
    for message in messages {
        if message.isMarked {
            dataBase.delete(message)
        }
    }
}

/*Вышесказанное определенно работает, но можно утверждать, что если бы мы реализовали его с использованием более декларативного стиля, мы бы получили более элегантное решение. Один из способов сделать это состоит в том, чтобы вместо этого использовать более функциональный подход и сначала отфильтровать наш массив сообщений, чтобы включить только те, которые были отмечены, а затем применить функцию database.delete к каждому элементу в отфильтрованной коллекции:*/

fileprivate func deleteMarkedMessages1(from messages: [Message], dataBase: DataBase) {
    messages.filter { $0.isMarked }.forEach(dataBase.delete)
}

/*Опять же, у нас есть совершенно правильный код, который выполняет эту работу, но - в зависимости от предпочтений нашей команды и знакомства с функциональным программированием - второе решение может выглядеть немного сложнее. С точки зрения производительности, это также требует от нас сделать два прохода через массив (один для фильтрации и один для применения функции удаления), а не только один - как в исходной реализации.
 
 Хотя есть способы оптимизировать вторую реализацию (например, с помощью компоновки функций или отложенных коллекций, о которых мы подробнее рассмотрим в следующих статьях) - оказывается, что сопоставление с образцом может дать нам довольно хороший баланс между двумя.
 
 Используя предложение where, мы можем прикрепить шаблон для сопоставления непосредственно к нашему исходному циклу for, что позволяет избавиться от этого вложенного оператора if - и то и другое делает нашу реализацию более декларативной и намного более простой - как это:*/
fileprivate func deleteMarkedMessages2(from messages: [Message], dataBase: DataBase) {
    for message in messages where message.isMarked {
        dataBase.delete(message)
    }
}

/*И это только верхушка айсберга. Мало того, что цикл for может сопоставляться с шаблоном с помощью предложения where, он также может делать это в пределах своего собственного определения элемента.
 
 Например, допустим, что мы работаем над игрой, которая включает в себя некий многопользовательский компонент создания матчей. Чтобы смоделировать совпадение, мы используем структуру, которая содержит дату начала матча и массив необязательных значений Player - где nil означает, что место по-прежнему открыто для игрока, с которым сравнивать:
*/
fileprivate struct Player {
    var name: String
    var image: UIImage
}

fileprivate class PlayerListView: UIView {
    func addEntryForPlayer(named: String, image: UIImage) { }
}

fileprivate struct Match {
    var startDate: Date
    var players: [Player?]

    func makePlayerListView(for players: [Player?]) -> UIView {
        let view = PlayerListView(frame: .zero)

        for case let player? in players {
            view.addEntryForPlayer(named: player.name, image: player.image)
        }

        return view
    }
}

// MARK: - Switching on optionals
/*Например, мы можем использовать следующее перечисление для представления состояния загрузки некоторой формы данные:*/
fileprivate enum LoadingState {
    //case none - можно не использовать, если сделать это перечисление ?
    case loading
    case failed(Error)
}
/*С учетом вышеуказанных изменений мы теперь вместо этого будем использовать LoadingState? когда мы хотим представить необязательное состояние загрузки - что кажется идеальным соответствием, но изначально может показаться, что это может усложнить обработку такого значения, поскольку нам нужно сначала развернуть это необязательное значение, а затем включить его.
 
 К счастью, возможности сопоставления с образцом в Swift снова приходят на помощь, так как, подобно тому, как мы использовали вопросительный знак после игрока при итерации по массиву опций, мы также можем ставить вопросительные знаки после каждого регистра enum в операторе switch, чтобы иметь возможность обрабатывать и ноль и фактические значения за один раз - вот так:*/

fileprivate class ContentViewController {
    func viewModel(loadingStateDidChangeTo state: LoadingState?) {
        switch state {
        case nil:
            removeLoadingSpinner()
            removeErrorView()
            renderContent()
        case .loading?:
            removeErrorView()
            showLoadingSpinner()
        case .failed(let error)?:
            removeLoadingSpinner()
            showErrorView(for: error)
        }
    }

    private func removeLoadingSpinner() { }
    private func removeErrorView() { }
    private func renderContent() { }
    private func showErrorView(for: Error) { }
    private func showLoadingSpinner() { }
}

// MARK: - Declarative error handling

/*Ошибки, связанные с тем, что пользователь не имеет доступа к Интернету.
 Маркер доступа пользователя стал недействительным.
 Другие ошибки, связанные с сетью.
 Любой другой вид ошибки.
 Вместо того, чтобы реализовывать вышеизложенное с использованием ряда операторов if и else с вложенными условиями и проверками, мы могли бы вместо этого использовать множество различных способов сопоставления шаблонов - снова позволяя нам реализовать всю нашу логику в одном декларативном переключателе утверждение - вот так:*/

fileprivate enum HTTPError: Error {
    case unauthorized
}

fileprivate func handle(_ error: Error) {
    func showOfflineView() { }
    func logOut() { }
    func showNetworkErrorView() { }
    func showGenericErrorView(for: Error) { }

    switch error {
    case URLError.notConnectedToInternet,
         URLError.networkConnectionLost,
         URLError.cannotLoadFromNetwork:
        showOfflineView()
    case let error as HTTPError where error == .unauthorized:
        logOut()
    case is HTTPError:
        showNetworkErrorView()
    default:
        showGenericErrorView(for: error)
    }
}

/////// - Under the hood with custom matching
func ~= < E: Error & Equatable > (rhs: E, lhs: Error) -> Bool {
    return (lhs as? E) == rhs
}

fileprivate func handle1(_ error: Error) {
    func showOfflineView() { }
    func logOut() { }
    func showNetworkErrorView() { }
    func showGenericErrorView(for: Error) { }

    switch error {
    case URLError.notConnectedToInternet,
         URLError.networkConnectionLost,
         URLError.cannotLoadFromNetwork:
        showOfflineView()
    case HTTPError.unauthorized:
        logOut()
    case is HTTPError:
        showNetworkErrorView()
    default:
        showGenericErrorView(for: error)
    }
}
