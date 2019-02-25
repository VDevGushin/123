//
//  AppCoordinator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

final class AppCoordinator {
    var currentDestination: Destination?

    enum Destination: Int, Equatable {
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

        static func == (lhs: Destination, rhs: Destination) -> Bool {
            return lhs.rawValue == rhs.rawValue
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
        guard self.currentDestination != destination else { return }
        self.currentDestination = destination
        let viewController = makeViewController(for: self.currentDestination!)
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
