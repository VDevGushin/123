//
//  Navigation.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 23/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Onboarding

fileprivate protocol OnboardingViewControllerDelegate: class {
    func onboardingViewControllerNextButtonTapped(_ viewController: OnboardingViewController)
}

fileprivate protocol OnboardingCoordinatorDelegate: class {
    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator)
}

fileprivate class OnboardingViewController: UIViewController {
    weak var delegate: OnboardingViewControllerDelegate?
    let page: OnboardingPage

    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func handleNextButtonTap() {
        delegate?.onboardingViewControllerNextButtonTapped(self)
    }
}

fileprivate class OnboardingPage {
    let nextPageIndex: Int
    init?(nextPageIndex: Int) {
        self.nextPageIndex = nextPageIndex
    }
}

//Coordinator
fileprivate class OnboardingCoordinator: OnboardingViewControllerDelegate {
    weak var delegate: OnboardingCoordinatorDelegate?

    private let navigationController: UINavigationController
    private var nextPageIndex = 0

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func activate() {
        self.goToNextPageOrFinish()
    }

    func onboardingViewControllerNextButtonTapped(_ viewController: OnboardingViewController) {
        self.goToNextPageOrFinish()
    }

    private func goToNextPageOrFinish() {
        guard let page = OnboardingPage(nextPageIndex: nextPageIndex) else {
            self.delegate?.onboardingCoordinatorDidFinish(self)
            return
        }

        let nextVC = OnboardingViewController(page: page)
        nextVC.delegate = self
        navigationController.pushViewController(nextVC, animated: true)
        nextPageIndex += 1
    }
}

// MARK: - Navigator
fileprivate enum Result<T> {
    case success(T)
    case error(Error)
}

fileprivate struct User { }

fileprivate class WelcomeViewController: UIViewController {
    private let user: User
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
fileprivate class PasswordResetViewController: UIViewController { }
fileprivate class SignUpViewController: UIViewController { }

fileprivate protocol Navigator {
    associatedtype Destination
    func navigate(to destination: Destination)
}

fileprivate class LoginNavigator: Navigator {
    enum Destination {
        case loginCompleted(user: User)
        case forgotPassword
        case signup
    }

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .loginCompleted(let user):
            return WelcomeViewController(user: user)
        case .forgotPassword:
            return PasswordResetViewController()
        case .signup:
            return SignUpViewController()
        }
    }
}

private class LoginViewController: UIViewController {
    private let navigator: LoginNavigator

    init(navigator: LoginNavigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func handleLoginButtonTap() {
        self.performLogin { [weak self] result in
            switch result {
            case .error(let error):
                self?.showE(error)
            case .success(let user):
                self?.navigator.navigate(to: .loginCompleted(user: user))
            }
        }
    }

    fileprivate func performLogin(then handler: (Result<User>) -> Void) {
        handler(.success(User()))
    }

    private func showE(_ error: Error) {

    }

    private func handleForgotPasswordButtonTap() {
        navigator.navigate(to: .forgotPassword)
    }

    private func handleSignUpButtonTap() {
        navigator.navigate(to: .signup)
    }
}
