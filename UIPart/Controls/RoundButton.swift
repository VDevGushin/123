//
//  RoundButton.swift
//  UIPart
//
//  Created by Vladislav Gushin on 19/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
