//
//  AppCoordinator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

final class AppCoordinator {
    enum Destination: Int {
        case mainView
        case lottieView
        case promiseKit

        var title: String {
            switch self {
            case .lottieView:
                return "Lottie"
            case .mainView:
                return "Menu"
            case .promiseKit:
                return "Promise Kit"
            }
        }
    }

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func close() {
        self.navigationController?.dismiss(animated: true)
    }


    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .mainView: return MainViewController.make(title: destination.title, navigator: self)
        case .lottieView: return LottieAnimationViewController.make(title: destination.title, navigator: self)
        case .promiseKit: return PromiseKitViewController.make(title: destination.title, navigator: self)
        }
    }

    static func navigation() -> UINavigationController {
        let navigationViewController = UINavigationController()
        let navigator = AppCoordinator(navigationController: navigationViewController)

        navigator.navigate(to: .mainView)
        return navigationViewController
    }
}
