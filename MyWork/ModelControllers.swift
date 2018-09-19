//
//  ModelControllers.swift
//  MyWork
//
//  Created by Vladislav Gushin on 22/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

private protocol UserModelFunctional: Hashable, Codable { }

private struct UserModelGroup: UserModelFunctional { }

private struct UserModelPermission: UserModelFunctional {
    struct Status: UserModelFunctional { }
    var allowComments = true
}

private struct UserModelPost: UserModelFunctional {
    let group: UserModelGroup
}

// Very common example
private class UserModel: Decodable, Encodable {
    let firstName: String
    let lastName: String
    let age: Int
    let groups: Set<UserModelGroup>
    let permissions: Set<UserModelPermission>
    init(data: (fn: String, ln: String, age: Int, groups: Set<UserModelGroup>, permissions: Set<UserModelPermission>)) {
        firstName = data.fn
        lastName = data.ln
        age = data.age
        groups = data.groups
        permissions = data.permissions
    }
}

extension UserModel {
    func canComment(on post: UserModelPost) -> Bool {
        guard groups.contains(post.group) else {
            return false
        }
        return self.permissions.contains {
            $0.allowComments == true
        }
    }
}

//Using model controler

private class UserModelController {
    private var user: UserModel
    init(user: UserModel) {
        self.user = user
    }

    func allowComments(on post: UserModelPost) -> Bool {
        guard user.groups.contains(post.group) else {
            return false
        }

        return user.permissions.contains {
            $0.allowComments == true
        }
    }
}

extension UserModelController {
    typealias PermissionsClosure = (UserModelPermission, UserModelPermission.Status) -> Void

    var displayName: String {
        return "\(self.user.firstName) \(self.user.lastName)"
    }

    func enumeratePermissions(using closure: PermissionsClosure) {
//        for permission in Permission.allCases {
//            let isGranted = user.permissions.contains(permission)
//            closure(permission, isGranted ? .granted : .denied)
//        }
    }
}

////With actions
//
//protocol UserModelControllerObserver: AnyObject {
//    func userModelControllerDidUpdate(_ controller: UserModelController)
//}
//
//extension UserModelController {
//    func addObserver(_ observer: UserModelControllerObserver) {
//        // See "Observers in Swift" for a full implementation
//    }
//}
////With actions
//class UserModelController {
//     private var user: User { didSet { notifyObservers() } } //for observers
//    private let dataLoader: DataLoader
//    
//    init(user: User, dataLoader: DataLoader) {
//        self.user = user
//        self.dataLoader = dataLoader
//    }
//    
//    func update(then handler: @escaping (Outcome) -> Void) {
//        let url = Endpoint.user.url
//        
//        dataLoader.loadData(from: url) { [weak self] result in
//            do {
//                switch result {
//                case .success(let data):
//                    let decoder = JSONDecoder()
//                    self?.user = try decoder.decode(User.self, from: data)
//                    handler(.success)
//                case .failure(let error):
//                    handler(.failure(error))
//                }
//            } catch {
//                handler(.failure(error))
//            }
//        }
//    }
//}
//
////Using
//class HomeViewController: UIViewController {
//    private let userController: UserModelController
//    private lazy var nameLabel = UILabel()
//    
//    init(userController: UserModelController) {
//        self.userController = userController
//        super.init(nibName: nil, bundle: nil)
//        userController.addObserver(self)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        render()
//    }
//    
//    private func render() {
//        nameLabel.text = userController.displayName
//    }
//}
//
//extension HomeViewController: UserModelControllerObserver {
//    func userModelControllerDidUpdate(_ controller: UserModelController) {
//        render()
//    }
//}
