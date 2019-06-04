//
//  Поддержание состояния в ваших ViewControllers.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 13/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*На прошлой неделе мы говорили о извлечении повторно используемых образцов кода из ViewControllers в протоколы и расширения протоколов. Сегодня я хочу показать вам еще один хороший пример использования протоколов при сохранении состояния ViewControllers.
 
 Предположим, что у нас есть экран для представления списка просмотренных пользователями передач - наше приложение загружает его из веб-службы, такой как Trakt. Мы можем описать состояние ViewController в трех переменных:*/
fileprivate struct Show { }

/*loading указывает, загружает ли ViewController данные или уже завершил работу.
 переменная shows хранит фактическую историю просмотренных телешоу.
 свойство error сообщает, завершился ли запрос ошибкой.*/
fileprivate class HistoryViewController: UIViewController {
    private let historyService = HistoryService()
    var loading: Bool = false {
        didSet {
            renderLoading()
        }
    }

    var shows: [Show]? {
        didSet {
            renderShows()
        }
    }

    var error: Error? {
        didSet {
            renderError()
        }
    }

    func renderLoading() { }
    func renderShows() { }
    func renderError() { }


    fileprivate func fetch() {
        self.loading = true
        historyService.fetch { [weak self] result in
            self?.loading = false
            switch result {
            case .success(let shows): self?.shows = shows
            case .failure(let error): self?.error = error
            }
        }
    }
}

fileprivate enum Result<T> {
    case success(T)
    case failure(Error)
}

fileprivate struct HistoryService {
    func fetch(then: (Result<[Show]>) -> Void) {
    }
}

/*Перед тем как начать наш запрос к веб-сервису Trakt, мы устанавливаем для загрузки значение true, которое вызывает метод renderLoading (). После этого мы инициируем запрос API для извлечения истории просмотренных телешоу. В обработчике завершения мы устанавливаем переменные show или error в соответствии с результатом запроса. На первый взгляд, это должно работать довольно хорошо, но здесь у нас есть пара недостатков.
 
1) Мы должны сбросить загрузку, ошибку, показывает переменные при каждом запросе, чтобы избежать недопустимого состояния. Например, в случае сбоя первого запроса и повторной попытки пользователя выполнить успешный запрос, у нас все еще есть значение в свойстве error.
2)  Мы хотим эксклюзивное состояние, в любой момент нам нужно только одно состояние экрана: ошибка или загрузка или показы. Прямо сейчас мы представляем больше состояний, чем у нас, и это может привести к неоднозначным ситуациям.*/

// MARK: - Enums
fileprivate enum State {
    case loading
    case error(Error)
    case loaded([Show])
}

fileprivate class HistoryViewController1: UIViewController {
    private var state: State = .loading {
        didSet {
            render()
        }
    }

    func render() {
        switch state {
        case .loading: break// render loading
        case .error: break// render error
        case .loaded: break// render shows
        }
    }
}
/*Здесь мы объявляем State enum, который описывает исключительно наши государственные дела. Как только переменная состояния изменяется, она вызывает метод рендеринга. Внутри метода рендеринга мы переключаем состояние для его отображения. Еще одно положительное изменение здесь - чистый доступ к состоянию экрана. Нам не нужно проверять все три переменные, чтобы понять, что происходит на экране прямо сейчас.*/

// MARK: - Protocols with associated types
// MARK: FINAL USAGE
fileprivate enum UniversalState<Data> {
    case loading
    case loaded(Data)
    case error(Error)
}

/*Давайте пойдем дальше и выделим обработку состояний в общий протокол с расширением протокола, который любой ViewController может адаптировать для добавления этой логики.*/

// Крутой протокол для активити
fileprivate enum ActivityPresentableState {
    case visible, hidden
}
fileprivate protocol ActivityPresentable {
    func presentActivity()
    func dismissActivity()
    func setActivityStatus(state: ActivityPresentableState)
}
extension ActivityPresentable where Self: UIViewController {

    func setActivityStatus(state: ActivityPresentableState) {
        switch state {
        case .visible: self.presentActivity()
        case .hidden: self.dismissActivity()
        }
    }

    func presentActivity() {
        if let activityIndicator = findActivity() {
            activityIndicator.startAnimating()
        } else {
            let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)

            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
        }
    }

    func dismissActivity() {
        findActivity()?.stopAnimating()
    }

    func findActivity() -> UIActivityIndicatorView? {
        return view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }
}

// Протокол для алертов ошибок
fileprivate protocol ErrorPresentable {
    func present(_ error: Error)
}
extension ErrorPresentable where Self: UIViewController {
    func present(_ error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

fileprivate protocol StatePresentable: ActivityPresentable, ErrorPresentable {
    associatedtype Data
    var state: UniversalState<Data> { get set }
    func render()
    func render(_ data: Data)
}

fileprivate extension StatePresentable {
    func render() {
        switch state {
        case .loading:
            setActivityStatus(state: .visible)
        case .error(let error):
            setActivityStatus(state: .hidden)
            present(error)
        case .loaded(let data):
            setActivityStatus(state: .hidden)
            render(data)
        }
    }
}

fileprivate class HistoryViewController2: UIViewController, StatePresentable {
    var state: UniversalState<[Show]> {
        didSet {
            render()
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.state = .loading
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(_ data: Array<Show>) {
    }
}


