//
//  StaticFactoryMethods.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UILabel {
    static func makeForTitle() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }
}

private extension UIButton {
    static func makeForBuying() -> UIButton {
        let button = UIButton()
        return button
    }
}

//How to use
class ProductViewController {
    private lazy var titleLabel = UILabel.makeForTitle()
    private lazy var buyButton = UIButton.makeForBuying()
}

extension UIViewController {
    static var loading: UIViewController {
        let viewController = UIViewController()

        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        viewController.view.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(
                equalTo: viewController.view.centerXAnchor
            ),
            indicator.centerYAnchor.constraint(
                equalTo: viewController.view.centerYAnchor
            )
        ])

        return viewController
    }
}

//How to use
class ProductListViewController: UIViewController {
    class ProductLaoder {
        func loadProducts(done: (Any?) -> Void) {
            done(nil)
        }
    }

    let productLoader = ProductLaoder()
    func loadProducts() {

        let loadingVC = UIViewController.loading
        add(loadingVC)
        productLoader.loadProducts { result in
            loadingVC.remove()
            //self?.handle(result)
        }
    }
}

