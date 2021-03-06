//
//  DIService.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 26/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Swinject

final class HelperAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UIApplication.self) { _ in
            UIApplication.shared
        }

        container.register(UserDefaults.self) { _ in
            UserDefaults.standard
        }

        container.register(Bundle.self) { _ in
            Bundle.main
        }

        container.register(FileManager.self) { _ in
            FileManager.default
        }
    }
}

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppCoordinator.self) { r in
            return AppCoordinator(navigationController: r.resolve(UINavigationController.self, name: "rootNavigationController")!)
        }

        container.register(Logger.self) { _ in
            FakeLogger()
        }.inObjectScope(.weak)
    }
}

class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UINavigationController.self, name: "rootNavigationController") { _ in
            UINavigationController()
        }.inObjectScope(.container)


        container.register(MainViewController.self) { _, navigator, title in
            MainViewController(navigator: navigator, title: title, nibName: String(describing: MainViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(LottieAnimationViewController.self) { _, navigator, title in
            LottieAnimationViewController(navigator: navigator, title: title, nibName: String(describing: LottieAnimationViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(PromiseKitViewController.self) { _, navigator, title in
            PromiseKitViewController(navigator: navigator, title: title, nibName: String(describing: PromiseKitViewController.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(SwinjectViewController.self) { r, navigator, title in
            SwinjectViewController(logger: r.resolve(Logger.self)!, navigator: navigator, title: title, nibName: String(describing: SwinjectViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(DayViewController.self) { r, navigator, title in
            DayViewController(navigator: navigator, title: title, nibName: String(describing: DayViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(CollectionViewsDynamicHeightViewController.self) { r, navigator, title in
            CollectionViewsDynamicHeightViewController(logger: r.resolve(Logger.self)!, navigator: navigator, title: title, nibName: String(describing: CollectionViewsDynamicHeightViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(RootContentViewController.self) { _, navigator, title in
            RootContentViewController(navigator: navigator, title: title, nibName: String(describing: RootContentViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(DiffExampleViewController.self) { _, navigator, title in
            DiffExampleViewController(navigator: navigator, title: title, nibName: String(describing: DiffExampleViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(DifferentCollectionLayoutCollectionViewController.self) { _, navigator, title in
            DifferentCollectionLayoutCollectionViewController(navigator: navigator, title: title, nibName: String(describing: DifferentCollectionLayoutCollectionViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(ExpandingCellsController.self) { _, navigator, title in
            ExpandingCellsController(navigator: navigator, title: title, nibName: String(describing: ExpandingCellsController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(StickyHeaderViewController.self) { _, navigator, title in
            StickyHeaderViewController(navigator: navigator, title: title, nibName: String(describing: StickyHeaderViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(TinderViewController.self) { _, navigator, title in
            TinderViewController(navigator: navigator, title: title, nibName: String(describing: TinderViewController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(CardGameController.self) { _, navigator, title in
            CardGameController(navigator: navigator, title: title, nibName: String(describing: CardGameController.self), bundle: nil)
        }.inObjectScope(.container)

        container.register(TimerViewController.self) { _, navigator, title in
            TimerViewController(navigator: navigator, title: title, nibName: String(describing: TimerViewController.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(DODOPizzaViewController.self) { _, navigator, title in
            DODOPizzaViewController(navigator: navigator, title: title, nibName: String(describing: DODOPizzaViewController.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(ScrollViewController.self) { _, navigator, title in
            ScrollViewController(navigator: navigator, title: title, nibName: String(describing: ScrollViewController.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(CollectionViewSelfSize.self) { _, navigator, title in
            CollectionViewSelfSize(navigator: navigator, title: title, nibName: String(describing: CollectionViewSelfSize.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(FromViewController.self) { _, navigator, title in
            FromViewController(navigator: navigator, title: title, nibName: String(describing: FromViewController.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(DragableInsideScrollViewController.self) { _, navigator, title in
            DragableInsideScrollViewController(navigator: navigator, title: title, nibName: String(describing: DragableInsideScrollViewController.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(ModalContainerViewController.self) { _, navigator, title in
            ModalContainerViewController.makeVC(title: title, coordinator: navigator)
        }.inObjectScope(.transient)

        container.register(OnboardingViewController.self) { _, navigator, title in
            OnboardingViewController(navigator: navigator, title: title, nibName: String(describing: OnboardingViewController.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(LocalizationKitViewController.self) { _, navigator, title in
            LocalizationKitViewController(navigator: navigator, title: title, nibName: String(describing: LocalizationKitViewController.self), bundle: nil)
        }.inObjectScope(.transient)

        container.register(CustomCollectionViewFlowLayoutViewController.self) { _, navigator, title in
            CustomCollectionViewFlowLayoutViewController(navigator: navigator, title: title, nibName: String(describing: CustomCollectionViewFlowLayoutViewController.self), bundle: nil)
        }.inObjectScope(.transient)
    }
}

final class DependencyProvider {
    static let shared = DependencyProvider()

    let container = Container()
    private let assembler: Assembler

    init() {
        assembler = Assembler(
            [
                HelperAssembly(),
                ServiceAssembly(),
                RepositoryAssembly()
            ],
            container: container
        )
    }
}
