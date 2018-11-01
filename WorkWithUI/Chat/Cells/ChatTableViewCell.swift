//
//  ChatTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 31/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var lastMessage: UILabel!

    func setChat(with: Chat) {
        DispatchQueue.main.async {
            self.author.text = ""
            self.lastMessage.text = ""
            self.title.text = "\(with.name ?? "...")"
     
            if let lastMessage = with.lastMessage, let profile = lastMessage.fromProfile {
                self.author.text = profile.name ?? ""
                self.lastMessage.text = lastMessage.text ?? ""
            }

            ChatStyle.titleLabel(self.title)
            ChatStyle.subTitleLabel(self.author)
            ChatStyle.subTitleLabel(self.lastMessage)
            ChatStyle.messageBackView(self.backView, ChatResources.defaultMessageColor)
        }
    }
}
