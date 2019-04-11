//
//  AppCoordinator.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

final class AppCoordinator {
    fileprivate var navigationController: UINavigationController
    var currentDestination: Destination?

    enum Destination: Int, Equatable, CaseIterable {
        case mainView
        case lottieView
        case promiseKit
        case swinject
        case alamofire
        case childVC
        case dynamicCollection
        case rootContent
        case diff
        case diffCollectionLayout
        case expandingCellsController

        var title: String {
            switch self {
            case .dynamicCollection:
                return "Dynamic collection"
            case .lottieView:
                return "Lottie"
            case .mainView:
                return "Menu"
            case .promiseKit:
                return "Promise Kit"
            case .swinject:
                return "Swinject Kit"
            case .alamofire:
                return "Alamofire"
            case .childVC:
                return "Child vc"
            case .rootContent:
                return "Root"
            case .diff:
                return "Animation with diff"
            case .diffCollectionLayout:
                return "Diff layout"
            case .expandingCellsController:
                return "Expanding Cells"
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
        case .mainView: return DependencyProvider.shared.container.resolve(MainViewController.self, arguments: self, destination.title)!
        case .lottieView: return DependencyProvider.shared.container.resolve(LottieAnimationViewController.self, arguments: self, destination.title)!
        case .promiseKit: return DependencyProvider.shared.container.resolve(PromiseKitViewController.self, arguments: self, destination.title)!
        case .swinject: return DependencyProvider.shared.container.resolve(SwinjectViewController.self, arguments: self, destination.title)!
        case .alamofire: return DependencyProvider.shared.container.resolve(AlamofireViewController.self, arguments: self, destination.title)!
        case .childVC: return DependencyProvider.shared.container.resolve(DayViewController.self, arguments: self, destination.title)!
        case .dynamicCollection: return DependencyProvider.shared.container.resolve(CollectionViewsDynamicHeightViewController.self, arguments: self, destination.title)!
        case .rootContent: return DependencyProvider.shared.container.resolve(RootContentViewController.self, arguments: self, destination.title)!
        case .diff: return DependencyProvider.shared.container.resolve(DiffExampleViewController.self, arguments: self, destination.title)!
        case .diffCollectionLayout: return DependencyProvider.shared.container.resolve(DifferentCollectionLayoutCollectionViewController.self, arguments: self, destination.title)!
        case .expandingCellsController:
            return DependencyProvider.shared.container.resolve(ExpandingCellsController.self, arguments: self, destination.title)!
        }
    }

    static func navigation() -> UINavigationController {
        let navigator = DependencyProvider.shared.container.resolve(AppCoordinator.self)!
        defer { navigator.navigate(to: .mainView) }
        return navigator.navigationController
    }
}
