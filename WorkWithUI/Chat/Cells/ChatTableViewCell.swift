//
//  ChatTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 31/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet private  weak var chatNameLabel: UILabel!
    
    var chat: Chat?
    
    func setChat(with: Chat) {
        self.chat = with
        self.chatNameLabel.text = "\(with.name ?? "testname")"
    }
}
