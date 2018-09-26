//
//  ColorView.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ColorView: UIView {
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var colorView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.setupUI()
    }

    func setup() {
        guard let view = loadFromNib() else { return }
        view.frame = bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    func loadFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }

    private func setupUI() {
        colorView.backgroundColor = .gray
        informationLabel.textColor = .black
    }

    func setColor(_ newColor: UIColor) {
        self.colorView.backgroundColor = newColor
        let newTextColor = newColor.lighter(by: 50)
        informationLabel.textColor = newTextColor
    }

    func setInfo(_ info: String) {
        self.informationLabel.text = info
    }
}
