//
//  Request.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 03/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public protocol Request {
    associatedtype Response
    typealias Handler = (Result<Response>) -> Void
    func perform(then handler: @escaping Handler)
}
