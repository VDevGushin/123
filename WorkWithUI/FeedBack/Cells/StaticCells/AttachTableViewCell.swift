//
//  AttachTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 12/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class AttachTableViewCell: UITableViewCell, IFeedbackStaticCell {
    @IBOutlet weak var fileSource: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var action: FeedBackCellAction?
    var initialSource: FeedBackCellIncomeData?
    var isReady: Bool = false

    func config(value: String, action: FeedBackCellAction) {
        if isReady { return }
        self.isReady.toggle()
        self.titleLabel.text = value
        self.action = action
        FeedBackStyle.titleLabel(self.titleLabel)
    }
    func check() { return }
    func setValue(with: String) { return }

    @IBAction func addAction(_ sender: Any) {
    }
}
