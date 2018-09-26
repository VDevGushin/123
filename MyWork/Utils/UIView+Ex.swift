//
//  UIView+Ex.swift
//  MyWork
//
//  Created by Vladislav Gushin on 02/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UIView {
    func loadFromNib(_ viewType: UIView.Type) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: viewType), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
    func setup() {
        guard let view = self.loadFromNib(ColorView.self) else { return }
        self.addSubview(view)
    }
}
