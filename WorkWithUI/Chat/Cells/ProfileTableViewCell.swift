//
//  ProfileTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 01/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var backView: UIView!

    func setProfile(with: Profile) {
        self.name.text = ""
        if let user = with.user {
            self.name.text = user.description
        }
        ChatStyle.titleLabel(self.name)
        ChatStyle.messageBackView(self.backView, ChatResources.defaultMessageColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // update UI
        accessoryType = selected ? .checkmark : .none
    }

//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                ChatStyle.messageBackView(self.backView, ChatResources.myMessageColor)
//            } else {
//                ChatStyle.messageBackView(self.backView, ChatResources.defaultMessageColor)
//            }
//        }
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        accessoryType = selected ? .checkmark : .none
//    }
}
