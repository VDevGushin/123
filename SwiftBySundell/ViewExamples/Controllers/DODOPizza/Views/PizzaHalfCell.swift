//
//  PizzaHalfCell.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class PizzaHalfCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    private var pizzaHalf: PizzaHalvesViewModel?

    private var halfOrientation: PizzaHalfOrientation = .left {
        didSet {
            imageView?.contentMode = halfOrientation == .left ? .topRight : .topLeft
            imageView.image = image(for: halfOrientation)
            setNeedsLayout()
        }
    }

    private func image(for side: PizzaHalfOrientation) -> UIImage {
        switch side {
        case .left: return UIImage(named: "left")!
        case .right: return UIImage(named: "right")!
        }
    }

    func setup(halfOrientation: PizzaHalfOrientation, pizzaHalf: PizzaHalvesViewModel) {
        self.halfOrientation = halfOrientation
        self.pizzaHalf = pizzaHalf
    }
}
