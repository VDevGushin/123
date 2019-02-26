//
//  AppCoordinator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

final class AppCoordinator {
    fileprivate unowned var navigationController: UINavigationController
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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func close() {
        self.navigationController.dismiss(animated: true)
    }

    func navigate(to destination: Destination) {
        guard self.currentDestination != destination else { return }
        self.currentDestination = destination
        let viewController = makeViewController(for: self.currentDestination!)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .mainView: return DIService.ci.resolve(MainViewController.self, arguments: self, destination.title)!
        case .lottieView: return DIService.ci.resolve(LottieAnimationViewController.self, arguments: self, destination.title)!
        case .promiseKit: return DIService.ci.resolve(PromiseKitViewController.self, arguments: self, destination.title)!
        }
    }

    static func navigation() -> UINavigationController {
        let rootNavigation = DIService.ci.resolve(UINavigationController.self, name: "rootNavigationController")!
        let navigator = DIService.ci.resolve(AppCoordinator.self, argument: rootNavigation)!
        defer { navigator.navigate(to: .mainView) }
        return rootNavigation
    }
}
