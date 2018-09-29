//
//  GradientView.swift
//  UIPart
//
//  Created by Vladislav Gushin on 29/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
//       // guard let view = self.loadFromNib(GradientView.self) else { return }
//        self.addSubview(view)
    }

    func setGradientBackGround( colors: [UIColor]?) {
        guard let colorsCollection = colors else { return }
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = colorsCollection.map({$0.cgColor})
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(gradientLayer)
    }
}
