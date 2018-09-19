//
//  TestProperty.swift
//  MyWork
//
//  Created by Vladislav Gushin on 10/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
private enum ScenarionTesttest {
    case spec(id: Int, title: Int)
    case datf(baseId: Int, description: Int)
}

private class VariantClass1 {
    var type: ScenarionTesttest?
}

private class TestWorker {
    enum Scen {
        case one
        case two
    }

    var s: Scen = .one

    func test() -> VariantClass1 {
        let vClass = VariantClass1()

        switch s {
        case .one:
            vClass.type = ScenarionTesttest.datf(baseId: 1, description: 1)
        case .two:
            vClass.type = ScenarionTesttest.spec(id: 1, title: 1)
        }

        return vClass
    }

    func getVariant() {
        let needVarinat = self.test()
        switch needVarinat.type! {
        case .datf(baseId: let id, description: let text):
            break
        case .spec(id: let id, title: let t):
            break
        }

    }
}
