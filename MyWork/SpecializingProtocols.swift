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


/*
 class DataLoader {
 func load(from endpoint: ProtectedEndpoint,
 onBehalfOf user: AuthenticatedUser,
 then: @escaping (Result<Data>) -> Void) {
 // Since 'AuthenticatedUser' inherits from 'User', we
 // get full access to all properties from both protocols.
 let request = makeRequest(for: endpoint,
 userID: user.id,
 accessToken: user.accessToken)

 }
 }
 */

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
