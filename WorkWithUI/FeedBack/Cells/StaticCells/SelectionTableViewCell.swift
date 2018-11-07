//
//  SelectionTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var action: FeedbackActions?
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet private weak var selectionButton: UIButton!

    @IBAction private func selectionAction(_ sender: Any) {
    }
}
