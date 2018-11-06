//
//  Result.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

enum Result<T> {
    case result(T)
    case error(Error)

    var value: T? {
        if case Result.result(let T) = self {
            return T
        }
        return nil
    }
}
