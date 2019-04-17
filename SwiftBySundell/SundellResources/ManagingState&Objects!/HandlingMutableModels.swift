//
//  HandlingMutableModels.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 10/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate struct Region {
    let value : String
}

fileprivate struct User {
    let id: UUID
    let name: String
    var region: Region?
    var email: String?
}

//Так как у нас есть неопределенные объекты, то скорее всего в коде у нас будет много операторов проверок
fileprivate func test(_ user: User) {
    guard let _ = user.region else {
        preconditionFailure("Not supposed to happen")
    }
}

// MARK: - Partial models
//Попробуем решим эту проблему
//Теперь мы будет использовать модель пользователя со всеми не опциональными полями, так как вспомогательный класс будет его создавать
fileprivate struct User1 {
    let id: UUID
    let name: String
    var region: Region
    var email: String
}

fileprivate struct PartialUser {
    let id: UUID
    let name: String
}

extension PartialUser {
    typealias CompletionInfo = (region: Region, email: String)
    func completed(with info: CompletionInfo) -> User1 {
        return User1(id: id, name: name, region: info.region, email: info.email)
    }
}

// MARK: - Partial immutability
//Можно ограничить доступ к полям модели через протоколы
protocol ImmutableUser {
    var id: UUID { get }
    var name: String { get }
}
extension User: ImmutableUser { }

fileprivate class MessageViewController: UIViewController {
    // It's safe for this view controller to store a copy of
    // the user, since it's guaranteed to be immutable.
    private let user: ImmutableUser

    init(user: ImmutableUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Observing mutations
//Класс для наблюдения за объектом
fileprivate class Observable<Value> {
    private var value: Value
    private var observations = [UUID: (Value) -> Void]()

    init(value: Value) {
        self.value = value
    }

    func update(with value: Value) {
        self.value = value
        for observation in self.observations.values {
            observation(value)
        }
    }

    func addObserver<O: AnyObject>(_ observer: O, using closure: @escaping (O, Value) -> Void) {
        let id = UUID()
        observations[id] = { [weak self, weak observer] value in
            guard let observer = observer else {
                self?.observations[id] = nil
                return
            }
            closure(observer, value)
        }
        closure(observer, value)
    }
}

// MARK: - Exclusive access
fileprivate class UserHolder {
    let immutable: ImmutableUser
    let mutable: Observable<User>

    init(user: User) {
        self.immutable = user
        mutable = Observable(value: user)
    }
}

fileprivate class ProfileViewController: UIViewController {
    private let userHolder: UserHolder
    private weak var nameLabel: UILabel?
    weak var regionLabel: UILabel?
    weak var emailLabel: UILabel?

    init(userHolder: UserHolder) {
        self.userHolder = userHolder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Immutable data can be read directly in a simple way
        nameLabel?.text = userHolder.immutable.name

        // Reading mutable data requires an observation, which
        // lets us guarantee that the view controller gets
        // updated whenever the underlying model changes.
        userHolder.mutable.addObserver(self) { (vc, user) in
            vc.regionLabel?.text = user.region?.value
            vc.emailLabel?.text = user.email
        }
    }
}
