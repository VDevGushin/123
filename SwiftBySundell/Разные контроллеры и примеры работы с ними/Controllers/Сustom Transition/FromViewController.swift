//
//  FromViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 17/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class FromViewController: CoordinatorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onGoAction(_ sender: Any) {
        let toVC = ToViewController(nibName: "ToViewController", bundle: nil)
        toVC.modalPresentationStyle = .fullScreen
        self.present(toVC, animated: true)
    }
}
