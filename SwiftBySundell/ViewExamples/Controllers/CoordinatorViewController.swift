//
//  CoordinatorViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class CoordinatorViewController: UIViewController {
    let viewTitle: String
    let navigator: AppCoordinator

    init(navigator: AppCoordinator,
         title: String,
         nibName: String,
         bundle: Bundle?) {

        self.viewTitle = title
        self.navigator = navigator
        super.init(nibName: nibName, bundle: bundle)
        self.navigationItem.title = title
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigator.currentDestination = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

