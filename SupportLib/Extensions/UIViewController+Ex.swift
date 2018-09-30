//
//  UIViewController+Ex.swift
//  MyWork
//
//  Created by Vladislav Gushin on 25/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        child.view.frame = self.view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.layoutSubviews()
    }

    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
