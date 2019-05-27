//
//  PizzaHalfTitleHeader.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class PizzaHalfTitleHeader: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!


    var halfOrientation: PizzaHalfOrientation = .left {
        didSet {
            switch halfOrientation {
            case .left:
                titleLabel.textAlignment = .left
                subtitleLabel.textAlignment = .left
            case .right:
                titleLabel.textAlignment = .right
                subtitleLabel.textAlignment = .right
            }
        }
    }

    func setup(title: String?, subtitle: String?, halfOrientation: PizzaHalfOrientation) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.halfOrientation = halfOrientation
    }
}
