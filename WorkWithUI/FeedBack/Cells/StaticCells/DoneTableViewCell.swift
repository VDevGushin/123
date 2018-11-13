//
//  DoneTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class DoneTableViewCell: UITableViewCell, IFeedbackStaticCell {
    weak var navigator: FeedBackNavigator?
    var titleLabel: UILabel!
    weak var delegate: IFeedbackStaticCellDelegate?
    var type: StaticCellType?
    var isReady: Bool = false
    func check() { }

    @IBOutlet private weak var sendButton: UIButton!

    weak var viewController: UIViewController?

    func config(value: String, type: StaticCellType, viewController: UIViewController, navigator: FeedBackNavigator?, delegate: IFeedbackStaticCellDelegate?) {
        if isReady { return }
        self.isReady.toggle()
        self.navigator = navigator
        self.delegate = delegate
        self.type = type
        sendButton.setTitle(FeedbackStrings.FeedBackView.send.value, for: .normal)
        FeedBackStyle.sendButton(self.sendButton)
    }


    @IBAction func doneAction(_ sender: Any) {
        guard let type = self.type else { return }
        if case StaticCellType.done = type {
            delegate?.cellSource(with: .done)
        }
    }

    func setValue(with: String) { }
}
