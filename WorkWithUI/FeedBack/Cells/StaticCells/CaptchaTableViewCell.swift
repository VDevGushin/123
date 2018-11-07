//
//  CaptchaTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class CaptchaTableViewCell: UITableViewCell, IFeedbackStaticCell {
    var action: FeedbackActions?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captcha: CaptchaView!
    @IBOutlet weak var input: UITextField!
}
