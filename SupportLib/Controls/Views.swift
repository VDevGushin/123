//
//  RoundView.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public final class RoundView: UIView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}

public final class RoundViewCornerRadius: UIView {
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layoutSubviews()
        }
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = true
    }
}


public final class ShadowView: UIView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 0, height: -0.5), radius: 0.5, scale: true)
    }
}
