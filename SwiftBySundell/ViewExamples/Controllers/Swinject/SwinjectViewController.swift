//
//  SwinjectViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class SwinjectViewController: CoordinatorViewController {
    private let logger: Logger

    init(logger: Logger,
         navigator: AppCoordinator,
         title: String,
         nibName: String,
         bundle: Bundle?) {
        self.logger = logger //DI
        super.init(navigator: navigator, title: title, nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logger.log(message: "Di success")
    }
}
