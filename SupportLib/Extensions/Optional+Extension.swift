//
//  Optional+Extension.swift
//  MyWork
//
//  Created by Vladislav Gushin on 21/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension Optional {
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

    func orDefault(default defaultExpression: @autoclosure () -> Wrapped) -> Wrapped {
        guard let value = self else {
            return defaultExpression()
        }
        return value
    }
}
