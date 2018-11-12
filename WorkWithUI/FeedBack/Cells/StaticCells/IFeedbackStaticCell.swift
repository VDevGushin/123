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
    var viewController: UIViewController? { get set }
    var action: FeedBackCellAction? { get set }
    var titleLabel: UILabel! { get set }
    func config(value: String, action: FeedBackCellAction, viewController: UIViewController)
    var isReady: Bool { get set }
    func check()
    var initialSource: FeedBackCellIncomeData? { get set }
    func setValue(with: String)
}
