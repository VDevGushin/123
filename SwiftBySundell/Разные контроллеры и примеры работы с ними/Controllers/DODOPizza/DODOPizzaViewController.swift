//
//  DODOPizzaViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class DODOPizzaViewController: CoordinatorViewController {
    @IBOutlet private weak var leftSide: UIView!
    @IBOutlet private weak var rightSide: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    fileprivate func setup() {
        let source = [PizzaHalvesViewModel(name: "Гавайская"),
            PizzaHalvesViewModel(name: "Супермясная"),
            PizzaHalvesViewModel(name: "Пепперони"),
            PizzaHalvesViewModel(name: "Маргарита")]
        
        let left = PizzaHalfCollectionController(side: .left)
        let right = PizzaHalfCollectionController(side: .right)
        
        left.halves = source
        right.halves = source
        self.add(left, to: self.leftSide)
        self.add(right, to: self.rightSide)
    }
}

fileprivate extension UIViewController {
    func add(_ child: UIViewController, to view: UIView) {
        addChild(child)
        child.view.frame = view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.layoutSubviews()
    }
}
