//
//  UIViewController+ex.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UIViewController {
    func addImageViewer(_ child: UIViewController) {
        addChild(child)
        child.view.frame = self.view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.layoutSubviews()
    }

    func addWithAnimaton(_ child: UIViewController) {
        addChild(child)
        child.view.alpha = 0
        child.view.frame = self.view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.layoutSubviews()
        UIView.animate(withDuration: 0.7, animations: {
            child.view.alpha = 1
        })
    }

    func removeWithAnimation() {
        guard parent != nil else { return }
        UIView.animate(withDuration: 0.7, animations: {
            self.view.alpha = 0
        }) { _ in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
}
