//
//  AnimatorPresent.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 17/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class AnimatorPresent: NSObject, UIViewControllerAnimatedTransitioning {
    let startFrame: CGRect

    init(startFrame: CGRect) {
        self.startFrame = startFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let vcTo = transitionContext.viewController(forKey: .to),
            let snapshot = vcTo.view.snapshotView(afterScreenUpdates: true) else {
                return
        }

        let vContainer = transitionContext.containerView

        vcTo.view.isHidden = true
        vContainer.addSubview(vcTo.view)

        snapshot.frame = self.startFrame
        vContainer.addSubview(snapshot)


        UIView.animate(withDuration: 0.3,
            animations: {
                snapshot.frame = (transitionContext.finalFrame(for: vcTo))
            }, completion: { success in
                vcTo.view.isHidden = false
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
    }
}
