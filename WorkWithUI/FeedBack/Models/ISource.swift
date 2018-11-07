//
//  ISource.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

protocol ISource {
    var innerTitle: String? { get set }
    var innerRaw: Any? { get set }
}
