//
//  Storyboardable.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 18/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol Storyboardable {
}

extension Storyboardable where Self: UIViewController {
    static func instantiateInitialFromStoryboard() -> Self {
        let controller = storyboard().instantiateViewController(withIdentifier: storyboardIdentifier)
        return controller as! Self
    }

    static func storyboard(fileName: String? = nil) -> UIStoryboard {
        let storyboard = UIStoryboard(name: fileName ?? storyboardIdentifier, bundle: nil)
        return storyboard
    }

    static var storyboardIdentifier: String {
        print(String(describing: self))
        return String(describing: self)
    }

    static var storyboardName: String {
        return self.storyboardIdentifier
    }
}
