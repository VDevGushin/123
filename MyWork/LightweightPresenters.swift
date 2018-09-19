//
//  LightweightPresenters.swift
//  MyWork
//
//  Created by Vladislav Gushin on 10/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class PresentVC: UIViewController { }

final class TestPresenterVC: UINavigationController {
    fileprivate func test() {
        let vc = PresentVC(nibName: "NibName", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//TODO:  - Presenters
private struct ConfirmationPresenter {
    enum Outcome {
        case accepted, rejected
    }
    let question: String
    let acceptTitlte: String
    let rejectTitle: String
    let handler: (Outcome) -> Void

    func present(in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: question, preferredStyle: .alert)

        let rejectAction = UIAlertAction(title: rejectTitle, style: .cancel) { _ in
            self.handler(.rejected)
        }

        let acceptAction = UIAlertAction(title: acceptTitlte, style: .default) { _ in
            self.handler(.accepted)
        }

        alert.addAction(rejectAction)
        alert.addAction(acceptAction)
        viewController.present(alert, animated: true)
    }
}

//Using ConfirmationPresenter

class NoteViewController: UIViewController {
    func handleDeleteButtonTap() {
        let presenter = ConfirmationPresenter(question: "Are you sure you want to delelete this note?", acceptTitlte: "Yes, delete it!", rejectTitle: "Cancel", handler: { [weak self] outcome in
            switch outcome {
            case .accepted: break
                //delete
            case .rejected:
                break
            }
        })
    }
}

//TODO: - Wrapping things up
 struct FavoritesManager { }
 struct FavoriteDataSource {
    let manager: FavoritesManager
}
final class MovieListViewController: UIViewController {
    let dataSource: FavoriteDataSource
    init(dataSource: FavoriteDataSource) {
        self.dataSource = dataSource
        super.init(nibName: "nibname", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private struct FavoritesPresenter {
    let manager: FavoritesManager

    func present(in viewController: UIViewController) {
        let dataSource = FavoriteDataSource(manager: manager)
        let list = MovieListViewController(dataSource: dataSource)
        let navigationController = UINavigationController(rootViewController: list)
        list.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: navigationController, action: #selector(UIViewController.dismiss(animated:completion:)))
        viewController.present(navigationController, animated: true)
    }
}

//Using
struct TutorialItem { }

private class HomveViewController: UIViewController {
    func presentFavirites() {
        let presenter = FavoritesPresenter(manager: FavoritesManager())
        presenter.present(in: self)
    }
}

final class TutorialViewController: UIViewController {
    private let item: TutorialItem
    var completionHandler: (() -> Void)?
    init(item: TutorialItem) {
        self.item = item
        super.init(nibName: "n", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//TODO: - Enqueued presentation
fileprivate final class TutorialPresenter {
    private let presentingViewController: UIViewController
    private weak var currentViewController: UIViewController?
    private var queue = [TutorialItem]()

    init(viewController: UIViewController) {
        presentingViewController = viewController
    }

    func present(_ item: TutorialItem) {
        guard currentViewController == nil else {
            queue.append(item)
            return
        }

        let viewController = TutorialViewController(item: item)

        viewController.completionHandler = { [weak self] in
            self?.currentViewController = nil
            self?.presentNextItemIfNeeded()
        }

        presentingViewController.present(viewController, animated: true)
        currentViewController = viewController
    }

    private func presentNextItemIfNeeded() {
        guard !queue.isEmpty else {
            return
        }

        present(queue.removeFirst())
    }
}
