//
//  UIViewController+Ex2.swift
//  MyWork
//
//  Created by Vladislav Gushin on 25/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UIViewController {    
    convenience init(_ controllerType: UIViewController.Type) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: String(describing: controllerType), bundle: bundle)
    }
}
