//
//  UsingChildViewControllers.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*
 Очень распространенная проблема при создании приложений для платформ Apple заключается в том, где разместить общую функциональность, которая используется многими различными контроллерами представления. С одной стороны, мaы хотим максимально избежать дублирования кода, а с другой стороны, мы хотим иметь хорошее разделение задач, чтобы избежать Massive View Controller.
 
 Примером такой общей функциональности является работа с состояниями загрузки и ошибок. Большинству контроллеров представления в приложении в какой-то момент потребуется асинхронная загрузка данных - операция, которая может занять некоторое время, а также может привести к сбою. Чтобы наши пользователи знали, что происходит, мы обычно хотим отображать какую-либо форму индикатора активности во время загрузки и отображение ошибки в случае сбоя операции.
 
 Так где же поставить такую функциональность? Очень распространенным решением является создание BaseViewController, от которого наследуются все наши другие контроллеры представления:
 */

// MARK: - Base view controller
fileprivate class BaseViewController: UIViewController {
    func showActivityIndicator() {

    }

    func hideActivityIndicator() {

    }

    func handle(_ error: Error) {

    }
}

// MARK: - Adding and removing a child view controller
// Добавление и удаление child view controller
fileprivate extension UIViewController {
    func add(_ child: UIViewController) {
        // Add the view controller as a child
        addChild(child)
        // Move the child view controller's view to the parent's view
        view.addSubview(child.view)
        // Notify the child that it was moved to a parent
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else { return }
        // Notify the child that it's about to be moved away from its parent
        willMove(toParent: nil)
        // Remove the child
        view.removeFromSuperview()
        // Remove the child view controller's view from its parent
        removeFromParent()
    }
}


// MARK: - Child view controllers
fileprivate class LoadingViewController: UIViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // We use a 0.5 second delay to not show an activity indicator
        // in case our data loads very quickly.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
}

fileprivate class ListViewController: UITableViewController {
    private lazy var dataLoader = ListViewController.Loader()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadItems()
    }

    private func loadItems() {
        let loadingViewController = LoadingViewController(nibName: nil, bundle: nil)
        self.add(loadingViewController)

        dataLoader.loadItems { [weak self] result in
            loadingViewController.remove()
            self?.handle(result)
        }
    }

    private func handle(_ result: String) {

    }

    private func handle(_ error: Error) {
        let errorViewController = ErrorViewController(nibName: nil, bundle: nil)
        errorViewController.reloadHandler = { [weak self] in
            self?.loadItems()
        }
        add(errorViewController)
    }

    class Loader {
        func loadItems(then: (String) -> Void) {
        }
    }
}

// MARK: - Error handling
fileprivate class ErrorViewController: UIViewController {
    var reloadHandler: () -> Void = { }
}
