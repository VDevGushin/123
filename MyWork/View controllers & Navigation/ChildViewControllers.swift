//
//  ChildViewControllers.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
