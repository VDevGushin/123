//
//  PersonStatisticCell.swift
//  MyWork
//
//  Created by Vladislav Gushin on 30/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class PersonStatisticCell: UITableViewCell {

    @IBOutlet weak var statistic: RoundPercentagesControl!
    @IBOutlet weak var variant: UILabel!
    @IBOutlet weak var name: UILabel!
    fileprivate let mode = PercentagesControlMode.single

    override func awakeFromNib() {
        super.awakeFromNib()
        self.statistic?.changeMode(with: .single)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(with data: Person) {
        self.statistic.update(with: data.statistic)
        self.statistic.changeMode(with: self.mode)
        self.name.text = data.name
        self.variant.text = data.variant.value
    }
}
