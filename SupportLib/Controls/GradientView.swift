//
//  GradientView.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final public class GradientView: UIView {
    let gradientLayer: CAGradientLayer
    public override init(frame: CGRect) {
        self.gradientLayer = CAGradientLayer()
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        self.gradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)
        self.backgroundColor = .red
    }

    public func setGradientBackground(colors: [UIColor]?, isHorisontal: Bool) {
        guard var colorsCollection = colors, colorsCollection.count > 0 else { return }
        if colorsCollection.count == 1 {
            self.backgroundColor = colorsCollection[0]
        }
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colorsCollection.map({ $0.cgColor })
        if isHorisontal {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        self.layer.addSublayer(gradientLayer)
        self.layoutSubviews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
