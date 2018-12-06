//
//  LocksANDKeys.swift
//  MyWork
//
//  Created by Vladislav Gushin on 26/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class RootFactory {
    private let urlSession: URLSession
    private let userManager: UserManager

    init(urlSession: URLSession = .shared,
         userManager: UserManager = .shared) {
        self.urlSession = urlSession
        self.userManager = userManager
    }
}

fileprivate extension RootFactory {
    func makeImageLoader() -> FImageLoader {
        return FImageLoader(urlSession: urlSession)
    }

    func makeLoginViewController() -> UIViewController {
        return LoginViewController(
            userManager: userManager,
            factory: self
        )
    }
}

fileprivate class FImageLoader {
    init(urlSession: URLSession) { }
}

fileprivate class LoginViewController: UIViewController {
    init(userManager: UserManager, factory: RootFactory) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class UserBoundFactory {
    private let user: User
    private let rootFactory: RootFactory

    init(user: User, rootFactory: RootFactory) {
        self.user = user
        self.rootFactory = rootFactory
    }

    func makeProfileViewController() -> UIViewController {
        let imageLoader = rootFactory.makeImageLoader()

        return Profile1ViewController(
            user: user,
            imageLoader: imageLoader
        )
    }
}

fileprivate class Profile1ViewController: UIViewController {
    init(
        user: User,
        imageLoader: FImageLoader
    ) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
