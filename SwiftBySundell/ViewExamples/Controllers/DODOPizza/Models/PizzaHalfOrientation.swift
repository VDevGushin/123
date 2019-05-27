//
//  PizzaHalfOrientation.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

enum PizzaHalfOrientation {
    case left
    case right

    func opposite() -> PizzaHalfOrientation {
        switch self {
        case .left: return .right
        case .right: return .left
        }
    }
}
