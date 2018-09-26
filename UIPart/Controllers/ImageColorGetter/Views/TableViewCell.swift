//
//  TableViewCell.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var colorView: ColorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func check(_ complete: () -> Void) {
        if colorView != nil {
            complete()
        }
    }

    func setColor(_ color: UIColor) {
        check {
            self.colorView.setColor(color)
        }
    }

    func setInfo(_ info: String) {
        check {
            self.colorView.setInfo(info)
        }
    }
}
