//
//  LightweightPresenters.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 17/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*
 Разделение интересов - идея о том, что каждый тип в идеале должен иметь четко определенную область ответственности - является одним из наиболее общепризнанных принципов программирования, но на практике это легче сказать, чем сделать.
 
 Особенно когда дело доходит до разработки пользовательского интерфейса, может быть действительно сложно четко отделить каждый тип от других, и, безусловно, нередко видеть, что такие классы, как представления и контроллеры представлений, заканчиваются большим набором функций и задач, поскольку им обычно приходится иметь дело со многими разными вещами, от макета до стиля, до реагирования на ввод пользователя.
 
 На этой неделе давайте посмотрим, как мы можем использовать шаблон презентатора для перемещения некоторых из этих задач, особенно связанных с представлением дополнительных пользовательских интерфейсов, из наших контроллеров представления в отдельные, выделенные типы.
 */

// MARK: - Presentation logic
//Допустим, мы хотим отобразить представление предупреждений, чтобы пользователь подтвердил действие - например, удаление элемента. Вместо того, чтобы контроллер представления сам настраивал представление оповещений, давайте инкапсулируем весь этот код в ConfirmationPresenter, например так:
fileprivate struct ConfirmationPresenter {
    enum Outcome {
        case rejected, accepted
    }

    let question: String
    let acceptTitle: String
    let rejectTitle: String
    let handler: (Outcome) -> Void

    func present(in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: question, preferredStyle: .alert)

        let rejectAction = UIAlertAction(title: rejectTitle, style: .cancel) { _ in
            self.handler(.rejected)
        }

        let acceptAction = UIAlertAction(title: acceptTitle, style: .default) { _ in
            self.handler(.accepted)
        }

        alert.addAction(rejectAction)
        alert.addAction(acceptAction)

        viewController.present(alert, animated: true)
    }
}

//Using
/*
 Прелесть вышеупомянутого подхода в том, что он позволяет нам легко повторно использовать наш код представления без необходимости создавать подкласс UIAlertController или использовать что-то вроде расширения в UIViewController - что добавило бы возможность отображать подтверждающее предупреждение всем контроллерам представления, даже тем, которые на самом деле это не нужно.
 */
fileprivate class NoteViewController: UIViewController {
    func handleDeleteButtonTap() {
        let presenter = ConfirmationPresenter(question: "Are you sure you want to delete this note?",
                                              acceptTitle: "Yes, delete it!",
                                              rejectTitle: "Cancel",
                                              handler: {
                                                  outcome in
                                                  switch outcome {
                                                  case .accepted: break
            case .rejected: break
                                                  }

                                              })
        presenter.present(in: self)
    }
}


// MARK: - Wrapping things up
/*
 Давайте посмотрим на другой пример, в котором мы используем MovieListViewController для отображения списка любимых фильмов пользователя. Наше приложение отображает списки фильмов в самых разных местах, поэтому мы сделали MovieListViewController очень гибким, чтобы поддерживать все эти варианты использования - позволяя вводить UITableViewDataSource в зависимости от контекста.
 
 Чтобы содержать весь этот установочный код, а также гарантировать, что наш MovieListViewController будет правильно упакован в контроллер навигации, давайте снова используем презентатор - на этот раз мы назовем его FavoritesPresenter:
 */
fileprivate struct FavorotesManager { }

fileprivate struct FavoritesDataSource {
    let manager: FavorotesManager
}

fileprivate struct FavoritesPresenter {
    let manager: FavorotesManager

    func present(in viewController: UIViewController) {
        let dataSource = FavoritesDataSource(manager: self.manager)
        let list = MovieListViewController(dataSource: dataSource)
        let navigationController = UINavigationController(rootViewController: list)
        list.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: navigationController, action: #selector(UIViewController.dismissWithAnimation))

        viewController.present(navigationController, animated: true)
    }
}

fileprivate extension UIViewController {
    @objc func dismissWithAnimation() {
        self.dismiss(animated: true, completion: nil)
    }
}

fileprivate class MovieListViewController: UIViewController {
    let dataSource: FavoritesDataSource
    init(dataSource: FavoritesDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Using
/*
 Еще одним приятным преимуществом этого подхода в этом случае является тот факт, что HomeViewController (и все другие контроллеры представления, представляющие избранное) не должны знать, что представленный контроллер представления заключен в UINavigationController - что дает нам гораздо большую гибкость в будущем. В случае, если мы хотим перейти к другой навигационной парадигме в будущем.
 */
fileprivate class HomeViewContrller: UIViewController {
    private lazy var manager = FavorotesManager()
    func presentFavorites() {
        let presenter = FavoritesPresenter(manager: self.manager)
        presenter.present(in: self)
    }
}

// MARK: - Enqueued presentation
fileprivate struct TutorialItem { }

fileprivate class TutorialViewController: UIViewController {
    let item: TutorialItem
    var completionHandler: () -> Void = { }

    init(item: TutorialItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class TutorialPresenter {
    private let presentingViewContrller: UIViewController
    private weak var currentViewController: UIViewController?
    private var queue = [TutorialItem]()

    init(viewController: UIViewController) {
        self.presentingViewContrller = viewController
    }

    //We can now simply call tutorialPresenter.present() from anywhere where we want to present a tutorial, and our presenter will take care of the rest! 👍
    func present(_ item: TutorialItem) {
        // If we're already presenting a tutorial item, we'll
        // add the next item to the queue and return.
        guard self.currentViewController == nil else {
            return self.queue.append(item)
        }

        let viewController = TutorialViewController(item: item)
        viewController.completionHandler = { [weak self] in
            self?.currentViewController = nil
            self?.presentNextItemIfNeeded()
        }

        self.presentingViewContrller.present(viewController, animated: true, completion: nil)
        self.currentViewController = viewController
    }

    func presentNextItemIfNeeded() {
        guard !self.queue.isEmpty else {
            return
        }
        self.present(self.queue.removeFirst())
    }
}
