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
        case customTransition
        case timer
        case cardGame
        case lottieView
        case promiseKit
        case swinject
        case childVC
        case dynamicCollection
        case rootContent
        case diff
        case diffCollectionLayout
        case expandingCellsController
        case stickyHeader
        case tinder
        case dodo
        case scroll
        case selfSizeCell
        case dragableInsideScrollViewController
        case modalContainerViewController
        case customCollectionViewFlowLayoutViewController
        var title: String {
            switch self {
            case .dragableInsideScrollViewController:
                return "Dragable Inside ScrollViewController"
            case .customTransition:
                return "Custom Transition"
            case .timer:
                return "TODO with timer"
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
            case .stickyHeader:
                return "Sticky header"
            case .tinder:
                return "tinder"
            case .cardGame:
                return "Card game"
            case .dodo:
                return "dodo"
            case .scroll:
                return "scroll"
            case .selfSizeCell:
                return "selfSizeCell"
            case .modalContainerViewController:
                return "Контроллер луковка"
            case .customCollectionViewFlowLayoutViewController:
                return "мой collectionviewFlow"
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

    func back() {
        self.navigationController.popViewController(animated: true)
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
        case .childVC: return DependencyProvider.shared.container.resolve(DayViewController.self, arguments: self, destination.title)!
        case .dynamicCollection: return DependencyProvider.shared.container.resolve(CollectionViewsDynamicHeightViewController.self, arguments: self, destination.title)!
        case .rootContent: return DependencyProvider.shared.container.resolve(RootContentViewController.self, arguments: self, destination.title)!
        case .diff: return DependencyProvider.shared.container.resolve(DiffExampleViewController.self, arguments: self, destination.title)!
        case .diffCollectionLayout: return DependencyProvider.shared.container.resolve(DifferentCollectionLayoutCollectionViewController.self, arguments: self, destination.title)!
        case .expandingCellsController:
            return DependencyProvider.shared.container.resolve(ExpandingCellsController.self, arguments: self, destination.title)!
        case .stickyHeader:
            return DependencyProvider.shared.container.resolve(StickyHeaderViewController.self, arguments: self, destination.title)!
        case .tinder:
            return DependencyProvider.shared.container.resolve(TinderViewController.self, arguments: self, destination.title)!
        case .cardGame:
            return DependencyProvider.shared.container.resolve(CardGameController.self, arguments: self, destination.title)!
        case .timer:
            return DependencyProvider.shared.container.resolve(TimerViewController.self, arguments: self, destination.title)!
        case .dodo:
            return DependencyProvider.shared.container.resolve(DODOPizzaViewController.self, arguments: self, destination.title)!
        case .scroll:
            return DependencyProvider.shared.container.resolve(ScrollViewController.self, arguments: self, destination.title)!
        case .selfSizeCell:
            return DependencyProvider.shared.container.resolve(CollectionViewSelfSize.self, arguments: self, destination.title)!
        case .customTransition:
            return DependencyProvider.shared.container.resolve(FromViewController.self, arguments: self, destination.title)!
        case .dragableInsideScrollViewController:
            return DependencyProvider.shared.container.resolve(DragableInsideScrollViewController.self, arguments: self, destination.title)!
        case .modalContainerViewController:
            return DependencyProvider.shared.container.resolve(ModalContainerViewController.self, arguments: self, destination.title)!
        case .customCollectionViewFlowLayoutViewController:
            return DependencyProvider.shared.container.resolve(CustomCollectionViewFlowLayoutViewController.self, arguments: self, destination.title)!
        }
    }

    static func navigation() -> UINavigationController {
        let navigator = DependencyProvider.shared.container.resolve(AppCoordinator.self)!
        defer { navigator.navigate(to: .mainView) }
        return navigator.navigationController
    }
}
