//
//  Optional+Ex.swift
//  MyWork
//
//  Created by Vladislav Gushin on 21/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension Optional {
    func unwrapOrThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }

    func map<T>(_ transform: (Wrapped) throws -> T?) rethrows -> T? {
        guard let value = self else {
            return nil
        }

        return try transform(value)
    }

    func orThrow<E: Error>(_ errorClosure: @autoclosure () -> E) throws -> Wrapped {
        guard let value = self else {
            throw errorClosure()
        }

        return value
    }
}
