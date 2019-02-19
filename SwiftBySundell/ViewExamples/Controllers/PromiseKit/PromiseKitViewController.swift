//
//  PromiseKitViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import PromiseKit

class PromiseKitViewController: CoordinatorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PromiseKitViewController {
    static func make(title: String, navigator: AppCoordinator) -> PromiseKitViewController {
        return PromiseKitViewController(navigator: navigator, title: title, nibName: String(describing: PromiseKitViewController.self), bundle: nil)
    }
}

