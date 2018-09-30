//
//  INavigator.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

protocol INavigator: class {
    associatedtype Destination
    func navigate(to destinaton: Destination)
}
