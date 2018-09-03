//
//  AvoidingSingletonsSwift.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class UserManager {
    class User {
        var name: String?
    }
    private init() { }
    static let shared = UserManager()
    var currentUser: User?
    func logOut() { }
}

class ProfileViewController: UIViewController {
    private lazy var nameLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = UserManager.shared.currentUser?.name
    }

    private func handleLogOutButtonTap() {
        UserManager.shared.logOut()
    }
}

//Решение - использовать dependency injection
protocol ILogOutService {
    func logOut()
}

protocol INetworkService {
    func request()
}

protocol INavigationService {
    func showLoginScreen()
    func showProfile(for user: UserManager.User)
}

class NetworkService {
    func loadData(from: URL, result: (Data) -> Void) {

    }
}
class NavigationService { }

class LogOutService {
    private let user: UserManager.User
    private let networkService: INetworkService
    private let navigationService: INavigationService

    init(user: UserManager.User,
         networkService: INetworkService,
         navigationService: INavigationService) {
        self.user = user
        self.networkService = networkService
        self.navigationService = navigationService
    }

    func logOut() { }
}

class ProfileViewControllerDI: UIViewController {
    private let user: UserManager.User
    private let logOutService: LogOutService
    private lazy var nameLabel = UILabel()

    init(user: UserManager.User, logOutService: LogOutService) {
        self.user = user
        self.logOutService = logOutService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user.name
    }

    private func handleLogOutButtonTap() {
        logOutService.logOut()
    }
}
