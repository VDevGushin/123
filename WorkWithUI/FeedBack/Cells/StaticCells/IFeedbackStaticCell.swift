//
//  IFeedbackStaticCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import UIKit

protocol IFeedbackStaticCellDelegate: class {
    func cellSource(with: FeedBackCellIncomeData)
}

protocol IFeedbackStaticCell: class {
    var navigator: FeedBackNavigator? { get set }
    var delegate: IFeedbackStaticCellDelegate? { get set }
    var viewController: UIViewController? { get set }
    var titleLabel: UILabel! { get set }
    var isReady: Bool { get set }
    var type: StaticCellType? { get set }
    func config(value: String, type: StaticCellType, viewController: UIViewController, navigator: FeedBackNavigator?, delegate: IFeedbackStaticCellDelegate?)
    func check()
    func setValue(with: String)
}
