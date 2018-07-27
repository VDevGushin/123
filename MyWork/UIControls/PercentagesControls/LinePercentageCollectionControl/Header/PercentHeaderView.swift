//
//  PercentHeaderView.swift
//  MyWork
//
//  Created by Vladislav Gushin on 27/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class PercentHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var roundControl: RoundPercentagesControl!

    func update(source: RoundPercentagesSource) {
        self.roundControl.update(with: source)
        self.reloadInputViews()
    }

    func setMode(new: RoundPercentagesControlMode) {
        self.roundControl.changeMode(with: new)
    }
}
