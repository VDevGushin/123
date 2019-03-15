//
//  DefaultEndPoint.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct DefaultEndPoint: EndPoint {
    var timeoutInterval: TimeInterval = 30

    var configurator: RequestConfigurator

    init(configurator: RequestConfigurator) {
        self.configurator = configurator
    }
}
