//
//  PromiseKit.swift
//  MyWork
//
//  Created by Vladislav Gushin on 19/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

class Creds {
    let name: String
    init(name: String) {
        self.name = name
    }
}

protocol IPromiseTest {
    func login() -> Promise<Creds>
    func login(completion: (Creds?, Error?) -> Void)
}

class PromiseTest: IPromiseTest {
    func login() -> Promise<Creds> {
        return Promise.value(Creds(name: "testname"))
    }

    func login(completion: (Creds?, Error?) -> Void) {
        completion(Creds(name: "testname"), nil)
    }

    func test () {
        firstly {
            login()
        }.done {
            print($0.name)
        }
    }
}
