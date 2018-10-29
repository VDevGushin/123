//
//  TestMock.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

class TestMock {
    func test() {
        let loader = ChatsLoader()
        loader.getAllChats {
            switch $0 {
            case .error(let error):
                print(error.localizedDescription)
            case .result(let value):
                dump(value)
            }
        }
    }
}
