//
//  MainViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainViewController {
    static func make() -> MainViewController {
        return MainViewController(nibName: String(describing: MainViewController.self), bundle: nil)
    }
}

