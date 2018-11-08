//
//  MultiIInputTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class MultiIInputTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var action: ActionsForStaticCells?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textInput: UITextView!

    func config(value: String, action: ActionsForStaticCells) {
        self.titleLabel.text = value
        self.action = action
        normalInputStyle()
        textInput.delegate = self
    }

    func wrongInputStyle() {
        FeedBackStyle.titleLabelWithError(self.titleLabel)
        FeedBackStyle.textViewWithError(self.textInput)
    }

    func normalInputStyle() {
        FeedBackStyle.titleLabel(self.titleLabel)
        FeedBackStyle.textView(self.textInput)
    }
}

extension MultiIInputTableViewCell: UITextViewDelegate {

}
