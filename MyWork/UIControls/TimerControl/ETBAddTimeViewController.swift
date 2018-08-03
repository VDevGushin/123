//
//  ETBAddTimeViewController.swift
//  MyWork
//
//  Created by Vladislav Gushin on 02/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ETBAddTimeViewController: UIViewController {
    static func viewController() -> ETBAddTimeViewController? {
        let vc = ETBAddTimeViewController.init(nibName: String(describing: ETBAddTimeViewController.self), bundle: nil)
        return vc
    }
    @IBOutlet weak var timerControl: ETBAddTimeViewControl!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
