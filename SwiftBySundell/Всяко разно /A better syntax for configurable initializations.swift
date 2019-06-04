//
//  A better syntax for configurable initializations.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 20/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class SomeView: UIView {
    var something: Int = 0
}


fileprivate class Test {
    let someView = Initializer<SomeView>.initialize {
        $0.backgroundColor = .green
        $0.something = 0
    }
    
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
}

final class Initializer<T: UIView> {
    static func initialize(config: (T) -> Void) -> T {
        let t = T()
        config(t)
        return t
    }
}
