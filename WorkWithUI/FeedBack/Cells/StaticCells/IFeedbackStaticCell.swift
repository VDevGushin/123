//
//  IFeedbackStaticCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import UIKit

protocol IFeedbackStaticCell: class {
    var action: FeedbackActions? { get set }
    var titleLabel: UILabel! { get set }
    func config(value: String, action: FeedbackActions)
}

extension IFeedbackStaticCell {
    func config(value: String, action: FeedbackActions) {
        self.titleLabel.text = value
        self.action = action
    }
}

