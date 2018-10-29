//
//  MessageCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    var message: Message?

    func setMessage(message: Message) {
        self.message = message
        self.messageText.text = "\(message.text ?? "testname")"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        setupViews()
        self.backgroundColor = .red
    }

    private func setupViews() {
        addSubview(messageText)
        messageText.layoutConstraint {
            $0.top.equal(to: topAnchor)
            $0.leftAnchor.equal(to: leftAnchor)
            $0.rightAnchor.equal(to: rightAnchor)
            $0.bottom.equal(to: bottomAnchor)
        }
    }

    private let messageText: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}

