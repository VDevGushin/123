//
//  ChatCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    var chat: Chat?

    func setChat(with: Chat) {
        self.chat = with
        self.chatName.text = "\(with.name ?? "testname")"
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
        self.backgroundColor = CalendarStyle.Colors.whiteFontColor
    }

    private func setupViews() {
        addSubview(chatName)
        chatName.layoutConstraint {
            $0.top.equal(to: topAnchor)
            $0.leftAnchor.equal(to: leftAnchor)
            $0.rightAnchor.equal(to: rightAnchor)
            $0.bottom.equal(to: bottomAnchor)
        }
    }
    
    private let chatName: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

