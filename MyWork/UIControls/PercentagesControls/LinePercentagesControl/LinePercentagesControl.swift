//
//  LinePercentagesControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 26/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

@IBDesignable
class LinePercentagesControl: UIView {
    private let xibName = String(describing: LinePercentagesControl.self)
    private var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var percent: UILabel!

    @IBOutlet weak var lineControl: LineControl!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension LinePercentagesControl: LineControlDelegate {
    func updatePercents(value: String) {
        self.percent.text = value
    }

    func update(with source: Set<RoundPercentagesSource.PercentagesType>) {
        self.lineControl.update(with: source)
    }

    func clear() {
        self.lineControl.clear()
    }

    func changeMode(with new: RoundPercentagesControlMode) {
        self.lineControl.changeMode(with: new)
    }

    func setColor(_ color: UIColor) {
        self.lineControl.setColor(color)
    }

    func setVariant(value: LinePercentagesSource.Variant) {
        self.title.text = value.value
    }
}

fileprivate extension LinePercentagesControl {
    func setup() {
        self.view = loadFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.lineControl.delegate = self
        self.title.text = LinePercentagesSource.Variant.value(0).value
    }

    func loadFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.xibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
}
