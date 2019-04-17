//
//  ComposingTypes.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*Композиция - это очень полезный метод, который позволяет нам разделять код между несколькими типами в более несвязной форме. Это часто преподносится как альтернатива подклассам, с такими фразами, как «Композиция над наследованием» - идея объединения функций из нескольких отдельных частей вместо того, чтобы полагаться на дерево наследования.
 
 Хотя создание подклассов / наследование также является чрезвычайно полезным (и фреймворки Apple, от которых мы все зависим, в значительной степени зависят от этого паттерна), существует много ситуаций, в которых использование композиции может позволить вам написать более простой и надежно структурированный код.
 
 На этой неделе давайте рассмотрим несколько таких ситуаций и то, как можно использовать композицию со структурами, классами и перечислениями в Swift.*/

// MARK: - Struct composition

/*Допустим, мы пишем приложение для социальных сетей, в котором есть модель User и модель Friend. Пользовательская модель используется для всех типов пользователей в нашем приложении, а модель друзей содержит те же данные, что и пользовательские, но также добавляет новую информацию - например, на дату, когда два пользователя стали друзьями.
 
 При принятии решения о том, как настроить эти модели, первоначальной идеей (особенно если вы пришли из языков, которые традиционно опирались на наследование, таких как Objective-C) может быть сделать Friend подклассом пользователя, который просто добавляет дополнительные данные, как это:
*/

fileprivate class User {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

fileprivate class Friend: User {
    var friendshipDate: Date
    init(name: String, age: Int, friendshipDate: Date) {
        self.friendshipDate = friendshipDate
        super.init(name: name, age: age)
    }
}

/*Хотя вышесказанное работает, у него есть некоторые недостатки. Три в частности:
 
 1)Чтобы использовать наследование, мы вынуждены использовать классы, которые являются ссылочными типами. Для моделей это означает, что мы можем легко ввести общее изменяемое состояние случайно. Если одна часть нашей кодовой базы изменяет модель, она будет автоматически отражаться везде, что может привести к ошибкам, если такие изменения не будут соблюдены и обработаны правильно.
 2)Поскольку Друг также является Пользователем, Друг может быть передан в функции, которые принимают экземпляр Пользователя. Это может показаться безвредным, но это увеличивает риск неправильного использования нашего кода, например, если экземпляр Friend передается такой функции, как saveDataForCurrentUser.
 3)Для друга мы на самом деле не хотим, чтобы свойства пользователя были изменяемыми (довольно сложно изменить имя друга 😅), но, поскольку мы полагаемся на наследование, мы также наследуем изменчивость всех свойств.
 Давайте использовать композицию вместо этого! Давайте создадим структуры User и Friend (что позволит нам использовать преимущества встроенных в Swift функций изменчивости), и вместо того, чтобы Friend непосредственно расширял User, давайте составим экземпляр User вместе с новыми данными, относящимися к другу, для формирования типа Friend, например:
*/

fileprivate struct User1 {
    var name: String
    var age: Int
}

fileprivate struct Friend1 {
    let user: User1
    var friendshipDate: Date
}

// MARK: - Class composition

/*Значит ли это, что мы должны создавать все наши типы структур? Я определенно так не думаю. Классы очень мощные, и иногда вы хотите, чтобы ваши типы имели семантику ссылок, а не семантику значений. Но даже если мы решим использовать классы, мы все равно можем использовать композицию в качестве альтернативы наследованию во многих ситуациях.
 
 Давайте создадим пользовательский интерфейс, который отображает список некоторых наших моделей Friend из предыдущего примера. Мы создадим контроллер представления - назовем его FriendListViewController - который имеет UITableView для отображения наших друзей.
 
 Один из наиболее распространенных способов реализации контроллера представления на основе табличного представления состоит в том, чтобы сам контроллер представления был источником данных для своего табличного представления (это даже то, к чему по умолчанию применяется UITableViewController)
 Я не собираюсь говорить, что делать вышеперечисленное плохо, и вы никогда не должны этого делать, но если мы хотим сделать эту функцию более разобщенной и многократно используемой - давайте вместо этого будем использовать композицию.
 
 Мы начнем с создания выделенного объекта источника данных, который соответствует UITableViewDataSource, которому мы можем просто назначить наш список друзей, и он будет снабжать табличное представление необходимой информацией:*/


fileprivate class FriendListTableViewDataSource: NSObject, UITableViewDataSource {
    var friends = [Friend1]()

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(frame: .zero)
    }
}

fileprivate class FriendListViewController: UIViewController {
    private weak var tableView: UITableView!
    private let dataSource = FriendListTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
    }

    func render(_ friends: [Friend1]) {
        dataSource.friends = friends
        tableView.reloadData()
    }
}

/*Прелесть этого подхода в том, что становится очень легко повторно использовать эту функцию, если мы хотим отобразить список друзей где-то еще в нашем приложении (например, в пользовательском интерфейсе «Найди друга»). В общем, удаление объектов из контроллеров представления может быть хорошим способом избежать синдрома «Massive view controller», и точно так же, как мы сделали наш источник данных отдельным, составным типом - мы можем сделать то же самое для других функций ( загрузка данных и изображений, кэширование и т. д.).
 
 Другой способ использования композиции с контроллерами представления, в частности, состоит в использовании дочерних контроллеров представления. Проверьте "Использование дочерних контроллеров представления в качестве плагинов в Swift" для получения дополнительной информации об этом.*/

// MARK: - Enum composition
/*Наконец, давайте посмотрим, как составление перечислений может дать нам более детальную настройку, которая может привести к меньшему дублированию кода. Допустим, мы создаем тип Operation, который позволяет нам выполнять тяжелую работу в фоновом потоке. Чтобы иметь возможность реагировать на изменения состояния операции, мы создаем перечисление State, в котором есть случаи, когда операция загружается, завершается неудачей или завершается:*/
fileprivate class Operation {
    enum State {
        case loading
        case failed(Error)
        case finished
    }

    private var state = State.loading
    private var action: ()throws -> Void

    init(_ actions: @escaping ()throws -> Void) {
        self.action = actions
    }

    func startWithStateHandler(then handler: (State) -> Void) {
        do {
            try self.action()
            self.state = .finished
            handler(self.state)
        } catch {
            self.state = .failed(error)
            handler(self.state)
        }
    }
}

fileprivate class ImageProcessor {
    func process(image: UIImage)throws {

    }
}

fileprivate class ImageProcessingViewController: UIViewController {
    func processImages(_ images: [UIImage]) {
        let operation = Operation {
            let processor = ImageProcessor()
            try images.forEach(processor.process)
        }

        operation.startWithStateHandler { [weak self] state in
            switch state {
            case .loading:
                self?.showActivityIndicatorIfNeeded()
            case .failed(let error):
                self?.cleanupCache()
                self?.removeActivityIndicator()
                self?.showErrorView(for: error)
            case .finished:
                self?.cleanupCache()
                self?.removeActivityIndicator()
                self?.showFinishedView()
            }
        }
    }

    func cleanupCache() { }
    func removeActivityIndicator() { }
    func showFinishedView() { }
    func showErrorView(for: Error) { }
    func showActivityIndicatorIfNeeded() { }
}

/*На первый взгляд может показаться, что с вышеприведенным кодом не все в порядке, но если мы поближе рассмотрим, как мы справляемся с неудачными и завершенными случаями, мы можем увидеть, что здесь есть некоторое дублирование кода.
 
 Дублирование кода не всегда плохо, но когда дело доходит до обработки различных состояний, подобных этой, обычно хорошей идеей является дублирование как можно меньшего количества кода. В противном случае нам придется писать больше тестов и проводить больше ручного контроля качества, чтобы протестировать все возможные пути к коду - и с большим количеством дублирования для ошибок легче проскальзывать через трещины, когда мы меняем вещи.
 
 Это еще одна ситуация, в которой композиция очень удобна. Вместо того, чтобы иметь только одно перечисление, давайте создадим два - одно для хранения нашего состояния, а другое для представления результата, например:*/

fileprivate class Operation1 {
    enum State {
        case loading
        case finished(Outcome)
    }

    enum Outcome {
        case failed(Error)
        case succeeded
    }

    private var state = State.loading
    private var action: ()throws -> Void

    init(_ actions: @escaping ()throws -> Void) {
        self.action = actions
    }

    func startWithStateHandler(then handler: (State) -> Void) {
        do {
            try self.action()
            self.state = .finished(.succeeded)
            handler(self.state)
        } catch {
            self.state = .finished(.failed(error))
            handler(self.state)
        }
    }
}

fileprivate class ImageProcessingViewController1: UIViewController {
    func processImages(_ images: [UIImage]) {
        let operation = Operation1 {
            let processor = ImageProcessor()
            try images.forEach(processor.process)
        }

        operation.startWithStateHandler { [weak self] state in
            switch state {
            case .loading:
                self?.showActivityIndicatorIfNeeded()
            case .finished(let outcome):
                self?.cleanupCache()
                self?.removeActivityIndicator()
                
                switch outcome {
                case .failed(let error):
                    self?.showErrorView(for: error)
                case .succeeded:
                    self?.showFinishedView()
                }
            }
        }
    }

    func cleanupCache() { }
    func removeActivityIndicator() { }
    func showFinishedView() { }
    func showErrorView(for: Error) { }
    func showActivityIndicatorIfNeeded() { }
}
