//
//  CustomContainerViewControllers.swift
//  MyWork
//
//  Created by Vladislav Gushin on 25/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate struct ProductLoaderForVC {
    func load(completion: (Result<Int>) -> Void) {
        completion(Result.result(5))
    }
}

fileprivate class ProductVC: UIViewController {
    let productLoader = ProductLoaderForVC()
    func loadProduct() {
        showActivityIndicator()
        productLoader.load { result in
            switch result {
            case .error(let error):
                break
            case .result(let result):
                break
            }
        }
    }

    func showActivityIndicator() {

    }

    func render() {

    }
}

//MARK: - using child view contollers
fileprivate class LoadingViewControllerForVC: UIViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
}

fileprivate class ErrorViewController: UIViewController {
    private lazy var errorLabel = UILabel(frame: CGRect.zero)
}

fileprivate class ProductContentVC: UIViewController {
    private lazy var productView = UIView()
}

//Create container

fileprivate class ContentStateViewController: UIViewController {
    private var state: StateForVC?
    private var shownViewController: UIViewController?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if state == nil {
            transition(to: .loading)
        }
    }

    func transition(to newState: StateForVC) {
        shownViewController?.remove()
        let vc = viewController(for: newState)
        add(vc)
        shownViewController = vc
        state = newState
    }
}

fileprivate extension ContentStateViewController {
    func viewController(for state: StateForVC) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case .failed:
            return ErrorViewController(nibName: nil, bundle: nil)
        case .render(let vc):
            return vc
        }
    }
}

fileprivate extension ContentStateViewController {
    enum StateForVC {
        case loading
        case failed(Error)
        case render(UIViewController)
    }
}


//MARK: - implementation time!
fileprivate class ProductVCV2: UIViewController {
    let productLoader = ProductLoaderForVC()
    private lazy var stateViewController = ContentStateViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        add(stateViewController)
    }


    func loadProduct() {
        showActivityIndicator()
        productLoader.load { [weak self] result in
            switch result {
            case .error(let error):
                self?.render(error: error)
            case .result(let result):
                self?.render(value: result)
            }
        }
    }

    func showActivityIndicator() {
        stateViewController.transition(to: .loading)
    }

    func render(error: Error) {
        stateViewController.transition(to: .failed(error))
    }

    func render(value: Int) {
        let contentVC = ProductContentVC(nibName: nil, bundle: nil)
        stateViewController.transition(to: .render(contentVC))
    }
}
