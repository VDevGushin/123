//
//  ModelControllers .swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 07/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//Использование model controllers в рамках mvc

// MARK : - Вспомогательные модельки для работы
fileprivate enum Outcome<T> {
    case success(T?)
    case error
}

fileprivate struct DataLoader {
    func load(from: String, handler: (Data) -> Void) { }
}

fileprivate struct Group: Codable, Hashable { }

fileprivate enum Permission: Int, Codable, Hashable, CaseIterable {
    case comments2
    case comments1
    case comments

    enum Status {
        case granted, denied
    }
}

fileprivate struct Post {
    let group: Group
}

fileprivate struct User: Codable {
    var firstName: String
    var lastName: String
    var age: Int
    var groups: Set<Group>
    var permissions: Set<Permission>
}

// ненужная логика для модели user
extension User {
    //перенесем эту логику в model controller
    func canComment(on post: Post) -> Bool {
        guard groups.contains(post.group) else {
            return false
        }
        return permissions.contains(.comments)
    }
}

// MARK : - Model controller
//Создадим model controller
fileprivate protocol UserModelControllerObserver: AnyObject {
    func userModelControllerDidUpdate(_ controller: UserModelController)
}

fileprivate class UserModelController {
    typealias PermissionsClosure = (Permission, Permission.Status) -> Void
    private var user: User { didSet { self.notifyObservers() } }
    private let dataLoader: DataLoader

    private struct Observation {
        weak var observer: UserModelControllerObserver?
    }

    private var observations = [ObjectIdentifier: Observation]()

    func addObserver(_ observer: UserModelControllerObserver) {
        let id = ObjectIdentifier(observer)
        self.observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: UserModelControllerObserver) {
        let id = ObjectIdentifier(observer)
        self.observations.removeValue(forKey: id)
    }

    private func notifyObservers() {
        for observation in self.observations.values {
            observation.observer?.userModelControllerDidUpdate(self)
        }
    }

    init(user: User, dataLoader: DataLoader) {
        self.user = user
        self.dataLoader = dataLoader
    }

    var displayName: String {
        return "\(user.firstName) \(user.lastName)"
    }

    func enumeratePermissions(using closure: PermissionsClosure) {
        for permission in Permission.allCases {
            let isGranted = user.permissions.contains(permission)
            closure(permission, isGranted ? .granted : .denied)
        }
    }

    //логика взятая из модели для разделения обязанностей
    func allowComments(on post: Post) -> Bool {
        guard user.groups.contains(post.group) else {
            return false
        }
        return user.permissions.contains(.comments)
    }

    func update(then handler: @escaping(Outcome<User>) -> Void) {
        let url = "url//"
        self.dataLoader.load(from: url) { [weak self] data in
            do {
                let decoder = JSONDecoder()
                self?.user = try decoder.decode(User.self, from: data)
                handler(.success(self?.user))
            } catch {
                handler(.error)
            }
        }
    }
}

// MARK : - Использование model controller во view controller
fileprivate class HomeViewController: UIViewController {
    private let userController: UserModelController
    private lazy var nameLabel = UILabel()

    init(userController: UserModelController) {
        self.userController = userController
        super.init(nibName: nil, bundle: nil)
        userController.addObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        nameLabel.text = userController.displayName
    }

    private func testController() {
        self.userController.update { result in
            ///
        }
    }
}

extension HomeViewController: UserModelControllerObserver {
    func userModelControllerDidUpdate(_ controller: UserModelController) {
        self.render()
    }
}
