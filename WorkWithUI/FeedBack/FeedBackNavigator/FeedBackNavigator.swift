//
//  FeedBackNavigator.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class FeedBackNavigator {
    private weak var navigationController: UINavigationController?

    enum Destination {
        case feedBackForm(initData: FeedBackInitForm?)
        case selection(title: String, worker: IFeedBackWorker, delegate: FeedBackSearchViewControllerDelegate?)
        case feedbackType
    }

    func close() {
        self.navigationController?.dismiss(animated: true)
    }

    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .feedBackForm(let value):
            return FeedBackTableViewController(navigator: self, initFormData : value)
        case .selection(let title, let worker, let delegate):
            let vc = FeedBackSearchViewController(navigator: self, title: title, worker: worker)
            vc.delegate = delegate
            return vc
        case .feedbackType:
            break
        }
        return UIViewController(nibName: nil, bundle: nil)
    }

    static func feedBackNavigation() -> UINavigationController {
        let navigationViewController = UINavigationController()
        ChatStyle.navigationBar(navigationViewController.navigationBar)
        let navigator = FeedBackNavigator(navigationController: navigationViewController)
        let f = FeedBackInitForm.init(name: "IOStest", lastName: "IOStest", middleName: "IOStest", phone: "123123", mail: "123@mai.ir")
        navigator.navigate(to: .feedBackForm(initData: f))
        return navigationViewController
    }
}
