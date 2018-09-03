//
//  HandlingMutableModels.swift
//  MyWork
//
//  Created by Vladislav Gushin on 27/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct Region { }

struct UserSample {
    let id: UUID
    let name: String
    var region: Region?
    var email: String?
}

fileprivate struct TestUser {
    var user: UserSample?
    func test() {
        guard let region = user?.region else {
            //fail
            return
        }
    }
}

struct PartialUser {
    let id: UUID
    let name: String
}

extension PartialUser {
    typealias CompletionInfo = (region: Region, email: String)

    func completed(with info: CompletionInfo) -> UserSample {
        return UserSample(id: id, name: name, region: info.region, email: info.email)
    }
}

protocol ImmutableUser {
    var id: UUID { get }
    var name: String { get }
}

extension UserSample: ImmutableUser { }

class MessageViewController: UIViewController {
    private let user: ImmutableUser
    init(user: ImmutableUser) {
        self.user = user
        super.init(nibName: "", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Observing mutations
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class UserHolder {
    let immutable: ImmutableUser
    let mutable: Observable<ImmutableUser>

    init(user: UserSample) {
        immutable = user
        mutable = Observable(value: user)
    }
}

class ProfileViewController1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let userHolder = UserHolder(user: UserSample(id: UUID(), name: "", region: nil, email: nil))

        // Immutable data can be read directly in a simple way

        // Reading mutable data requires an observation, which
        // lets us guarantee that the view controller gets
        // updated whenever the underlying model changes.
        userHolder.mutable.addObserver(self) { (vc, user) in
            //
        }
    }
}

class Observable<Value> {
    private var value: Value
    private var observations = [UUID: (Value) -> Void]()

    init(value: Value) {
        self.value = value
    }

    func update(with value: Value) {
        self.value = value
        for observer in observations.values {
            observer(value)
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
        // Directly call the observation closure with the
        // current value.
        closure(observer, value)
    }
}


