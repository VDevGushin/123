//
//  AvoidingRaceConditions.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*
 Условие гонки - это то, что происходит, когда ожидаемый порядок завершения последовательности операций становится непредсказуемым, в результате чего логика нашей программы оказывается в неопределенном состоянии. Например, мы могли бы обновить пользовательский интерфейс до того, как его содержимое было полностью загружено, или случайно показать экран, предназначенный только для зарегистрированных пользователей, прежде чем пользователь полностью войдет в систему.
 
 Race условия могут поначалу часто казаться случайными и могут быть действительно сложными для отладки - поскольку зачастую трудно (или даже невозможно) придумать для них надежные шаги воспроизведения. На этой неделе давайте рассмотрим общий сценарий, который может привести к гоночным ситуациям, возможные способы их избежать - и как мы можем сделать наш код более устойчивым и предсказуемым в процессе.
 
 Давайте начнем с рассмотрения примера, в котором мы создаем AccessTokenService, чтобы мы могли легко получить токен доступа для выполнения какой-либо формы аутентифицированного сетевого запроса. Наш сервис инициализируется с помощью AccessTokenLoader, который выполняет фактическую работу в сети, в то время как сам сервис действует как API верхнего уровня и имеет дело с такими вещами, как кэширование и проверка токенов - выглядит так:
 */

fileprivate struct AccessToken {
    var isValid: Bool
}

fileprivate class AccessTokenLoader {
    func load(then handler: ((AccessToken) -> Void)) {

    }
}

fileprivate enum Result<T> {
    case value(T)
    case error(Error)
}

fileprivate class AccessTokenService {
    typealias Handler = (Result<AccessToken>) -> Void
    private let loader: AccessTokenLoader
    private var token: AccessToken?

    init(loader: AccessTokenLoader) {
        self.loader = loader
    }

    func retrieveToken(then handler: @escaping Handler) {
        if let token = self.token, token.isValid {
            return handler(.value(token))
        }

        self.loader.load { [weak self] result in
            self?.token = result
            handler(.value(result))
        }
    }
}

// MARK: - Enqueueing pending handlers
/*Вышеприведенный класс может выглядеть очень просто, и если он используется изолированно - так и есть. Однако, если мы посмотрим немного ближе к нашей реализации, мы увидим, что если метод retrieveToken вызывается дважды - и второй вызов происходит до того, как загрузчик завершил загрузку - мы фактически закончим загрузкой двух токенов доступа. Для некоторых серверов аутентификации это может быть большой проблемой, так как часто только один токен доступа может быть действительным в любой момент времени - очень вероятно, что в результате мы получим условие состязания, когда второй запрос приведет к аннулированию результата первый.
 Включение в очередь ожидающих обработчиков
 Итак, как мы можем предотвратить возникновение такого рода расы? Первое, что мы можем сделать, это убедиться, что никакие дублирующие запросы не выполняются параллельно, и вместо этого ставить в очередь любые обработчики, передаваемые в retrieveToken, пока загрузчик занят загрузкой.
 Для этого мы начнем с добавления массива pendingHandlers в нашу службу маркеров доступа - и каждый раз, когда вызывается метод retrieveTokens, мы добавляем переданный обработчик в этот массив. Затем мы будем выполнять только один запрос в любой момент времени, проверяя, содержит ли наш массив только один элемент, и вместо непосредственного вызова текущего обработчика после завершения работы загрузчика, мы вызовем новый закрытый метод с именем справиться:
 */
fileprivate class AccessTokenServiceWithQueue {
    typealias Handler = (Result<AccessToken>) -> Void
    private let loader: AccessTokenLoader
    private var token: AccessToken?
    private var pendingHandlers = [Handler]()

    init(loader: AccessTokenLoader) {
        self.loader = loader
    }

    func retrieveToken(then handler: @escaping Handler) {
        if let token = self.token, token.isValid {
            return handler(.value(token))
        }

        self.pendingHandlers.append(handler)
        guard pendingHandlers.count == 1 else { return }

        self.loader.load { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: AccessToken) {
        self.token = result
        let handlers = self.pendingHandlers
        self.pendingHandlers = []
        handlers.forEach { $0(.value(result)) }
    }
}
/*
 Теперь у нас есть гарантия, что даже если retrieveToken вызывается несколько раз подряд, в итоге будет загружен только один токен - и все обработчики будут уведомлены в правильном порядке 👍.
 
 Поставив в очередь обработчики асинхронного завершения, как мы это делали выше, мы можем проделать долгий путь, когда речь идет об избежании состояний гонки в коде, который имеет дело с одним источником состояния, - но у нас все еще есть одна важная проблема, которую мы должны решить - безопасность потоков.
 */
// MARK: - Thread safety

/*
 Пока наш код выполняется в том же потоке, мы можем полагаться на данные, которые мы читаем и пишем из свойств наших объектов, чтобы быть правильными. Однако, как только мы введем многопоточный параллелизм, два потока могут закончить чтение или запись в одно и то же свойство в одно и то же время, что приведет к немедленному устареванию данных одного из потоков.
 
 Например, до тех пор, пока наш AccessTokenService ранее использовался в одном потоке, механизм, который мы создали для работы с условиями гонки, помещая в очередь ожидающие обработчики завершения, будет работать нормально, но если несколько потоков в конечном итоге используют одну и ту же службу маркеров доступа , мы можем быстро оказаться в неопределенном состоянии, как только наш массив pendingHandlers будет одновременно мутирован из нескольких потоков. Еще раз, у нас есть состояние гонки в наших руках.
 
 Несмотря на то, что существует много способов справиться с условиями многопотоковой гонки, один довольно простой способ сделать это на платформах Apple - это использовать мощь Grand Central Dispatch, которая позволяет нам работать с потоками, используя гораздо более простые абстракции на основе очереди. ,
 
 Давайте вернемся к нашему AccessTokenService и сделаем его поточно-ориентированным, используя выделенную функцию DispatchQueue для синхронизации своего внутреннего состояния. Мы начнем с принятия внедренной очереди в инициализаторе нашего сервиса (чтобы упростить тестирование) или создадим новую, затем - после вызова нашего метода retrieveToken - отправим асинхронное закрытие в нашу очередь, в которой мы будем на самом деле выполнить поиск токена, в результате чего наш класс теперь выглядит так:
 */

fileprivate class AccessTokenServiceWithGCD {
    typealias Handler = (Result<AccessToken>) -> Void

    private let loader: AccessTokenLoader
    private let queue: DispatchQueue
    private var token: AccessToken?
    private var pendingHandlers = [Handler]()

    init(loader: AccessTokenLoader,
         queue: DispatchQueue = .init(label: "AccessToken")) {
        self.loader = loader
        self.queue = queue
    }

    func retrieveToken(then handler: @escaping Handler) {
        self.queue.async { [weak self] in
            self?.performRetrieval(with: handler)
        }
    }
    /*Как и раньше, мы просто вызываем закрытый метод внутри нашего асинхронного замыкания, вместо того, чтобы добавлять множество собственных ссылок. В нашем новом методе executeRetrieval мы будем запускать ту же логику, что и раньше - с добавлением, которое мы теперь также переносим в вызов для обработки в асинхронной диспетчеризации очереди - для обеспечения полной безопасности потока:*/
    private func performRetrieval(with handler: @escaping Handler) {
        if let token = self.token, token.isValid {
            return handler(.value(token))
        }

        self.pendingHandlers.append(handler)

        guard self.pendingHandlers.count == 1 else { return }

        self.loader.load { [weak self] result in
            self?.queue.async {
                handler(.value(result))
            }
        }
    }
}
