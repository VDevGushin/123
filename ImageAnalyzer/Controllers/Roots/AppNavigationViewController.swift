//
//  AppNavigationViewController.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class AppNavigationViewController: UINavigationController {
    var imageNavigator: ImageProcessNavigator?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageNavigator = ImageProcessNavigator(navigationController: self)
    }
}
