//
//  DoneTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class DoneTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var titleLabel: UILabel!
    var action: FeedbackActions?
    func config(value: String, action: FeedbackActions) {
        self.action = action
    }

    @IBAction func doneAction(_ sender: Any) {
        guard let action = self.action else { return }
        if case FeedbackActions.done(let done) = action {
            done()
        }
    }
}
