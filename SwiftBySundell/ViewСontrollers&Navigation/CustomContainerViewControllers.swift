//
//  CustomContainerViewControllers.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 21/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Managing state
/*
 Большая часть кода пользовательского интерфейса вращается вокруг управления состоянием так или иначе. Возможно, мы ожидаем, пока пользователь заполнит форму, или загрузим содержимое, пока мы показываем загрузочный счетчик. Часто изменения в состоянии означают переход к новому пользовательскому интерфейсу - например, отображение табличного представления и скрытие счетчика загрузки, когда содержимое представления становится доступным.
 
 Обычно один контроллер представления отвечает за переход между такими состояниями, а также за их рендеринг. Например, вот как мы можем заставить ProductViewController обрабатывать его состояния загрузки, ошибок и рендеринга:
 */
fileprivate class ProductView: UIView { }
fileprivate struct Product { }
fileprivate enum Result<T> {
    case success(T)
    case error(Error)
}

fileprivate class ProductLoader {
    func loadProduct(with: Int, then handler: (Result<Product>) -> Void) {
        handler(.success(Product()))
    }
}

fileprivate class ProductViewController: UIViewController {
    private let productLoader: ProductLoader
    init(productLoader: ProductLoader) {

        self.productLoader = productLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadProduct(productID: Int) {
        self.productLoader.loadProduct(with: productID) { [weak self] result in
            switch result {
            case .error(let error): self?.render(error)
            case .success(let product): self?.render(product)
            }

        }
    }

    private func showActivityIndicator() {
        // Activity indicator setup and rendering
    }

    private func render(_ product: Product) {
        // Product view setup and rendering
    }

    private func render(_ error: Error) {
        // Error view setup and rendering
    }
}
/*
 Вышеприведенное может показаться не таким уж плохим, но, как мы все знаем, контроллеры представлений несут гораздо больше обязанностей, чем просто загрузка и рендеринг контента. После того, как мы добавим наш код компоновки, отвечая на системные события, такие как появление клавиатуры, и на все другие задачи, которые мы обычно выполняем в наших контроллерах представления - скорее всего, у нас есть еще один контроллер Massive View.
 */

// MARK: - Child view controllers
fileprivate class LoadingViewController: UIViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
}

fileprivate class ErrorViewController: UIViewController {
    private lazy var errorLabel = UILabel()
    init(error: Error) {
        super.init(nibName: nil, bundle: nil)
        self.errorLabel.text = error.localizedDescription
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class ProductContentViewController: UIViewController {
    private lazy var productView = ProductView()
    init(product: Product){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Creating a container
fileprivate enum State {
    case loading
    case failed(Error)
    case render(UIViewController)
}

fileprivate class ContentStateViewController: UIViewController {
    private var state: State?
    private var shownViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        if state == nil {
            transition(to: .loading)
        }
    }

    func transition(to newState: State) {
        shownViewController?.remove()
        let vc = viewController(for: newState)
        add(vc)
        shownViewController = vc
        state = newState
    }

    private func viewController(for state: State) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case .failed(let error):
            return ErrorViewController(error: error)
        case .render(let viewController):
            return viewController
        }
    }

}

fileprivate extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// MARK: - It's implementation time!
fileprivate class ProductViewControllerNormalVersion: UIViewController {
    private lazy var stateViewController = ContentStateViewController()
    private let productLoader: ProductLoader
    init(productLoader: ProductLoader) {
        self.productLoader = productLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(stateViewController)
    }
    
    func loadProduct(productID: Int) {
        productLoader.loadProduct(with: productID) { [weak self] result in
            switch result {
            case .success(let product):
                self?.render(product)
            case .error(let error):
                self?.render(error)
            }
        }
    }
    
    private func render(_ product: Product) {
        let contentVC = ProductContentViewController(product: product)
        stateViewController.transition(to: .render(contentVC))
    }
    
    private func render(_ error: Error) {
        stateViewController.transition(to: .failed(error))
    }
}
