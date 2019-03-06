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
        //firstly
        self.container.register(UINavigationController.self, name: "rootNavigationController") { _ in
            UINavigationController()
        }


        self.registerServices()
        self.registerVC()
    }

    private func registerServices() {
        self.container.register(AppCoordinator.self) { r in
            return AppCoordinator(navigationController: r.resolve(UINavigationController.self, name: "rootNavigationController")!)
        }

        self.container.register(Logger.self) { _ in
            FakeLogger()
        }

        self.container.register(AlamofireDataController.self) { _ in
            RealAlamofireDataController()
        }
    }

    private func registerVC() {

        self.container.register(MainViewController.self) { _, navigator, title in
            MainViewController(navigator: navigator, title: title, nibName: String(describing: MainViewController.self), bundle: nil)
        }

        self.container.register(LottieAnimationViewController.self) { _, navigator, title in
            LottieAnimationViewController(navigator: navigator, title: title, nibName: String(describing: LottieAnimationViewController.self), bundle: nil)
        }

        self.container.register(PromiseKitViewController.self) { _, navigator, title in
            PromiseKitViewController(navigator: navigator, title: title, nibName: String(describing: PromiseKitViewController.self), bundle: nil)
        }

        self.container.register(SwinjectViewController.self) { r, navigator, title in
            SwinjectViewController(logger: r.resolve(Logger.self)!, navigator: navigator, title: title, nibName: String(describing: SwinjectViewController.self), bundle: nil)
        }

        self.container.register(AlamofireViewController.self) { r, navigator, title in
            AlamofireViewController(dataController: r.resolve(AlamofireDataController.self)!, navigator: navigator, title: title, nibName: String(describing: AlamofireViewController.self), bundle: nil)
        }

        self.container.register(DayViewController.self) { r, navigator, title in
            DayViewController(navigator: navigator, title: title, nibName: String(describing: DayViewController.self), bundle: nil)
        }
    }
}
