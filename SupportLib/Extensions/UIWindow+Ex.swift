//
//  UIWindow+Ex.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public extension UIWindow {
    func makeFor(navigationController: @autoclosure () -> UINavigationController, childControllers: @autoclosure () -> [UIViewController]) {
        let nVC = navigationController()
        let cVC = childControllers()
        nVC.setViewControllers(cVC, animated: true)
        self.rootViewController = nVC
        self.makeKeyAndVisible()
    }
}
