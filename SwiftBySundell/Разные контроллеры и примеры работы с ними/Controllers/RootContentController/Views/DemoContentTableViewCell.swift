//
//  DemoContentTableViewCell.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 12/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class DemoContentTableViewCell: UITableViewCell {
    @IBOutlet weak var lllll: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lllll.text = nil
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
    }
}
