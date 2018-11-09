//
//  DoneTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class DoneTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var initialSource: StaticCellsSource?
    var isReady: Bool = false
    
    func check() { }
    var titleLabel: UILabel!
    var action: ActionsForStaticCells?
    @IBOutlet private weak var sendButton: UIButton!

    func config(value: String, action: ActionsForStaticCells) {
        if isReady { return }
        self.isReady.toggle()
        self.action = action
        sendButton.setTitle(FeedbackStrings.FeedBackView.send.value, for: .normal)
        FeedBackStyle.sendButton(self.sendButton)
    }

    @IBAction func doneAction(_ sender: Any) {
        guard let action = self.action else { return }
        if case ActionsForStaticCells.done(let done) = action { done(.done) }
    }
}
