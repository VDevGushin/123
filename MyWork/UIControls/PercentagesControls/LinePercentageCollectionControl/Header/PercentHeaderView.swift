//
//  PercentHeaderView.swift
//  MyWork
//
//  Created by Vladislav Gushin on 27/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

@IBDesignable
class PercentHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var roundControl: RoundPercentagesControl!

    @IBOutlet weak var globalTitle: UILabel!
    @IBOutlet weak var globalSubTitle: UILabel!

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!

    func update(source: RoundPercentagesSource) {
        self.roundControl.update(with: source)
        self.reloadInputViews()
    }

    func setMode(new: RoundPercentagesControlMode) {
        self.roundControl.changeMode(with: new)
    }
}
