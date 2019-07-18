//
//  UIViewController+Ext.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 18/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UIViewController {
    func insertFullframeChildController(_ childController: UIViewController,
                                        toView: UIView? = nil, index: Int) {
        
        let containerView: UIView = toView ?? view
        
        addChild(childController)
        containerView.insertSubview(childController.view, at: index)
        containerView.pinToBounds(childController.view)
        childController.didMove(toParent: self)
    }
}
