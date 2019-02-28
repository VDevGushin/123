//
//  FakeLogger.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

struct FakeLogger: Logger {
    func log(message: String) {
        print(message)
    }
}
