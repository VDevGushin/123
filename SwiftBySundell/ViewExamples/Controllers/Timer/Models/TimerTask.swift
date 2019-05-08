//
//  TimerTask.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 08/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

class TimerTask {
    let name: String
    let creationDate = Date()
    var completed = false

    init(name: String) {
        self.name = name
    }
}
