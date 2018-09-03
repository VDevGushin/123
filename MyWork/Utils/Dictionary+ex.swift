//
//  Dictionary+ex.swift
//  MyWork
//
//  Created by Vladislav Gushin on 03/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

private extension Dictionary where Key == String {
    func value<V>(for key: Key,
                  default defaultExpression: @autoclosure () -> V) -> V {
        return (self[key] as? V) ?? defaultExpression()
    }
}
