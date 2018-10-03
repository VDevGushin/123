//
//  MethodsPerformers.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 03/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public func perform<T>(_ f: @autoclosure () throws -> T, orThrow: (Error) -> Error)throws -> T {
    do {
        return try f()
    } catch {
        throw orThrow(error)
    }
}
//  let data: Data = try self.perform(file.read(), orThrow: LoadingError.invalidData)

infix operator ~>
func ~> <T>(expression: @autoclosure () throws -> T,
            errorTransform: (Error) -> Error) throws -> T {
    do {
        return try expression()
    } catch {
        throw errorTransform(error)
    }
}
//let data = try file.read() ~> LoadingError.invalidData
