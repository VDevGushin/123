//
//  SpecializingProtocols.swift
//  MyWork
//
//  Created by Vladislav Gushin on 22/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate protocol IUser {
    var id: UUID { get }
    var name: String { get }
}

fileprivate protocol IAuthenticatedUser: IUser {
    var accessToken: String { get }
}

// MARK: - Specialization
fileprivate protocol Component {
    associatedtype Container
    func add(to container: Container)
}

fileprivate protocol ViewComponent: Component where Container: UIView {
    var view: UIView { get }
}

extension ViewComponent {
    func add(to container: Container) {
        container.addSubview(view)
    }
}

// MARK: - Composition

fileprivate protocol Operation {
    associatedtype Input
    associatedtype Output

    func prepare()
    func cancel()
    func perform(with input: Input, then handler: @escaping (Output) -> Void)
}

//разделим обязанности по протоколам
//typealias Codable = Decodable & Encodable
typealias IOperation = IPreparable & ICancellable & IPerformable

protocol IPreparable {
    func prepare()
}

protocol ICancellable {
    func cancel()
}

protocol IPerformable {
    associatedtype Input
    associatedtype Output
    func perform(with input: Input, then handler: @escaping (Output) -> Void)
}

extension Sequence where Element == ICancellable {
    func cancelAll() {
        forEach {
            $0.cancel()
        }
    }
}
