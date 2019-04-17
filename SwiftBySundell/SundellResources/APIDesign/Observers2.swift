//
//  Observers2.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 05/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
fileprivate enum State {
    case idle
    case playing(Item)
    case paused(Item)
}

fileprivate struct Item {
    let title: String
    let duration: String
}

// MARK: - Closures
/*Замыкания являются огромной частью современного дизайна API. От асинхронных API с обратными вызовами до функциональных операций (например, использование forEach или map для коллекции) - замыкания есть везде, как в стандартной библиотеке Swift, так и в приложениях, которые мы пишем сторонними разработчиками.
 
 Прелесть замыканий в том, что они позволяют пользователям API захватывать текущий контекст, в котором они находятся, и использовать его при реагировании на событие - в нашем случае, когда состояние нашего AudioPlayer изменяется. Это позволяет создать более «легкий» сайт вызовов, что может привести к упрощению кода, но замыкания также имеют свой собственный набор компромиссов.
 
 Давайте посмотрим, как мы можем добавить API наблюдения на основе замыканий к нашему AudioPlayer. Мы начнем с определения кортежа, который мы будем использовать для отслеживания массивов замыканий наблюдений, которые были добавлены для каждого из наших трех событий - запущены, приостановлены и остановлены, например:*/

fileprivate class AudioPlayer {
    var state: State = .idle
    private var observations = (
        started: [(AudioPlayer, Item) -> Void](),
        paused: [(AudioPlayer, Item) -> Void](),
        stopped: [(AudioPlayer) -> Void]()
    )
}

/*Конечно, мы могли бы использовать отдельные свойства выше - но, как мы уже рассмотрели в разделе «Использование кортежей в качестве облегченных типов в Swift», - использование кортежей для группировки связанных свойств может быть действительно удобным способом упорядочить вещи простым способом.
 
 Далее давайте определимся с нашими методами наблюдения. Как и наши предыдущие подходы, мы определим один метод для каждого события наблюдения, делая вещи четко разделенными. Каждый метод занимает закрытие, и мы продолжим передавать текущий элемент воспроизведения запущенному и приостановленному наблюдателям, просто передав самого проигрывателя остановленным:*/
fileprivate extension AudioPlayer {
    func observePlaybackStarted(using closure: @escaping (AudioPlayer, Item) -> Void) {
        observations.started.append(closure)
    }

    func observePlaybackPaused(using closure: @escaping (AudioPlayer, Item) -> Void) {
        observations.paused.append(closure)
    }

    func observePlaybackStopped(using closure: @escaping (AudioPlayer) -> Void) {
        observations.stopped.append(closure)
    }
}
/*Передача самого игрока во все замыкания, как правило, является хорошей практикой, чтобы избежать случайных циклов удержания, если игрок используется в одном из своих замыканий наблюдений, и мы забываем фиксировать его слабо. Для получения дополнительной информации проверьте «Захват объектов в замыканиях Swift».
 
 С учетом вышесказанного все, что остается, - это вызвать все закрытия наблюдений для соответствующего события, когда состояние игрока меняется, например:*/
fileprivate extension AudioPlayer {
    func stateDidChange() {
        switch state {
        case .idle:
            observations.stopped.forEach { $0(self) }
        case .paused(let item):
            observations.paused.forEach { $0(self, item) }
        case .playing(let item):
            observations.started.forEach { $0(self, item) }
        }
    }
}

// MARK: - View controller
fileprivate class NowPlayingViewController {
    private let player = AudioPlayer()
    func viewDidLoad() {
        ///...
        player.observePlaybackPaused { player, item in
            _ = item.duration
        }
    }
}

/*Тем не менее, есть один существенный недостаток вышеупомянутого подхода - нет способа удалить наблюдение. Хотя это хорошо для объектов, которым принадлежит объект, который они наблюдают (поскольку наблюдаемый объект будет освобожден вместе с его владельцем), он не идеален для общих объектов (что, вероятно, будет наш AudioPlayer), поскольку добавленные наблюдения будут в значительной степени остаться навсегда.*/

// MARK: - Tokens

/*Одним из способов удаления наблюдений является использование токенов. Точно так же, как мы это делали в «Использование токенов для обработки асинхронного кода Swift», мы можем возвращать ObservationToken каждый раз, когда добавляется замыкание наблюдения, которое впоследствии можно использовать для отмены наблюдения и удаления замыкания.
 
 Давайте начнем с создания самого класса токена, который просто действует как обертка вокруг замыкания, которое можно вызвать для отмены наблюдения:*/
fileprivate class ObservationToken {
    private let cancellationClosure: () -> Void

    init(cancellationClosure: @escaping () -> Void) {
        self.cancellationClosure = cancellationClosure
    }

    func cancel() {
        self.cancellationClosure()
    }
}
/*Поскольку замыкания на самом деле не имеют понятия идентичности, нам нужно добавить какой-то способ уникальной идентификации наблюдения, чтобы можно было его удалить. Один из способов сделать это - просто превратить наш массив замыканий из ранее в словари, используя значения UUID в качестве ключей, например так:
*/

fileprivate class AudioPlayerWithCancelToken {
    var state: State = .idle
    private var observations = (
        started: [UUID: (AudioPlayerWithCancelToken, Item) -> Void](),
        paused: [UUID: (AudioPlayerWithCancelToken, Item) -> Void](),
        stopped: [UUID: (AudioPlayerWithCancelToken) -> Void]()
    )

    func stateDidChange() {
        switch state {
        case .idle:
            observations.stopped.values.forEach { closure in
                closure(self)
            }
        case .playing(let item):
            observations.started.values.forEach { closure in
                closure(self, item)
            }
        case .paused(let item):
            observations.paused.values.forEach { closure in
                closure(self, item)
            }
        }
    }
}

fileprivate extension AudioPlayerWithCancelToken {
    @discardableResult
    func observePlaybackStarted(using closure: @escaping (AudioPlayerWithCancelToken, Item) -> Void)
        -> ObservationToken {
            let id = observations.started.insert(closure)

            return ObservationToken { [weak self] in
                self?.observations.started.removeValue(forKey: id)
            }
    }

    @discardableResult
    func observePlaybackPaused(using closure: @escaping (AudioPlayerWithCancelToken, Item) -> Void)
        -> ObservationToken {
            let id = observations.paused.insert(closure)

            return ObservationToken { [weak self] in
                self?.observations.paused.removeValue(forKey: id)
            }
    }

    @discardableResult
    func observePlaybackStopped(using closure: @escaping (AudioPlayerWithCancelToken) -> Void)
        -> ObservationToken {
            let id = observations.stopped.insert(closure)

            return ObservationToken { [weak self] in
                self?.observations.stopped.removeValue(forKey: id)
            }
    }
}



private extension Dictionary where Key == UUID {
    mutating func insert(_ value: Value) -> UUID {
        let id = UUID()
        self[id] = value
        return id
    }
}

//Using
fileprivate class NowPlayingViewController1: UIViewController {
    private var observationToken: ObservationToken?
    private let player = AudioPlayerWithCancelToken()
    deinit {
        observationToken?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        observationToken = player.observePlaybackStarted { player, item in
            _ = "\(item.duration)"
        }
    }
}

// MARK: - The best of both worlds
/*Давайте рассмотрим способ сохранить наш основанный на токене API (поскольку он добавляет ценность, предоставляя нам более детальный контроль над нашими наблюдениями), но все же сокращает шаблон.
 
 Один из способов сделать это - привязать замыкание наблюдения ко времени существования самого наблюдателя, не требуя от наблюдателя соответствия определенному протоколу (как мы это делали с AudioPlayerObserver на прошлой неделе). Что мы сделаем, так это добавим API, который позволит нам передавать любой объект в качестве наблюдателя, а также передавать замыкание, как раньше. Затем мы слабо захватим этот объект и защитим от того, что он равен нулю, чтобы определить, является ли наблюдение еще действительным, например так:*/
fileprivate extension AudioPlayerWithCancelToken {
    @discardableResult
    func addPlaybackStartedObserver<T: AnyObject>(_ observer: T, closure: @escaping (T, AudioPlayerWithCancelToken, Item) -> Void
    ) -> ObservationToken {
        let id = UUID()

        observations.started[id] = { [weak self, weak observer] player, item in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.started.removeValue(forKey: id)
                return
            }

            closure(observer, player, item)
        }

        return ObservationToken { [weak self] in
            self?.observations.started.removeValue(forKey: id)
        }
    }
}

 class NowPlayingViewController2: UIViewController {
    private let player = AudioPlayerWithCancelToken()
    override func viewDidLoad() {
        super.viewDidLoad()

        player.addPlaybackStartedObserver(self) {
            vc, player, item in
            _ = "\(item.duration)"
        }
    }
}
