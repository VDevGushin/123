//
//  DIService.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 26/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Swinject

final class DIService {
    static var ci: Container {
        return self.shared.container
    }

    private let container: Container
    static let shared = DIService()

    private init() {
        self.container = Container()
        self.makeRegistration()
    }

    func makeRegistration() {
        self.container.register(UINavigationController.self, name: "rootNavigationController") { _ in
            UINavigationController()
        }

        self.container.register(AppCoordinator.self) { _, navigationController in
            return AppCoordinator(navigationController: navigationController)
        }

        self.container.register(MainViewController.self) { _, navigator, title in
            MainViewController(navigator: navigator, title: title, nibName: String(describing: MainViewController.self), bundle: nil)
        }

        self.container.register(LottieAnimationViewController.self) { _, navigator, title in
            LottieAnimationViewController(navigator: navigator, title: title, nibName: String(describing: LottieAnimationViewController.self), bundle: nil)
        }

        self.container.register(PromiseKitViewController.self) { _, navigator, title in
            PromiseKitViewController(navigator: navigator, title: title, nibName: String(describing: PromiseKitViewController.self), bundle: nil)
        }
    }
}
