//
//  Navigation.swift
//  MyWork
//
//  Created by Vladislav Gushin on 27/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//MARK: - navigator
fileprivate protocol Navigator {
    associatedtype Destination
    func navigate(to destinaton: Destination)
}

class LoginNavigator: Navigator {
    enum Destination {
        case loginComplete(user: User)
        case forgotPassword
        case singup
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
        case .forgotPassword:
            return PasswordResetViewController()
        case .singup:
            return SignUpViewController()
        case .loginComplete(user: let user):
            return WelcomeViewController(user: user)
        }
    }
}

final class PasswordResetViewController: UIViewController { }
final class SignUpViewController: UIViewController { }
final class WelcomeViewController: UIViewController {
    let user: User
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - using navigator
fileprivate class LoginViewController: UIViewController {
    private let navigator: LoginNavigator

    init(navigator: LoginNavigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func handleLoginButtonTap() {
        performLogin { [weak self] result in
            switch result {
            case .error(let error):
                self?.show(error: error)
            case .result(let user):
                self?.navigator.navigate(to: .loginComplete(user: user))
            }
        }
    }

    private func show(error: Error) { }

    private func handleForgotPasswordButtonTap() {
        navigator.navigate(to: .forgotPassword)
    }

    private func handleSignUpButtonTap() {
        navigator.navigate(to: .singup)
    }

    private func performLogin(completion: (Result<User>) -> Void) {
        completion(Result.result(User()))
    }
}

