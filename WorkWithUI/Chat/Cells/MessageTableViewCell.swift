//
//  MessageTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class MessageTableViewCell: UITableViewCell {
    private let sideIndent: CGFloat = 25.0
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leftConstraint: NSLayoutConstraint!

    var message: Message?

    func setMessage(message: Message) {
        self.message = message
        self.messageLabel.text = "\(message.text ?? "...")"
        self.timeLabel.text = ChatResources.dateFormatter.string(from: message.createdAt)
        self.authorLabel.text = message.fromProfile?.name ?? "..."

        ChatStyle.messageText(self.messageLabel)
        ChatStyle.subTitleLabel(self.timeLabel)
        ChatStyle.subTitleLabel(self.authorLabel)

        if message.fromProfileId == ChatResources.pid {
            ChatStyle.messageBackView(self.backView, ChatResources.myMessageColor)
            rightConstraint?.constant = 8.0
            leftConstraint?.constant = self.sideIndent
        } else {
            ChatStyle.messageBackView(self.backView, ChatResources.defaultMessageColor)
            rightConstraint?.constant = self.sideIndent
            leftConstraint?.constant = 8.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
