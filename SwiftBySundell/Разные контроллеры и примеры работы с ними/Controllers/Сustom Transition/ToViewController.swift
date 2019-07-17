//
//  ToViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 17/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class ToViewController: UIViewController {
    @IBOutlet private weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

    @IBAction func onReturnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ToViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatorPresent(startFrame: self.button.frame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatorDismiss(endFrame: self.button.frame)
    }
}
