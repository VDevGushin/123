//
//  CellSource.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 11/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

enum StaticCellType: Int {
    case name
    case lastName
    case middleName
    case organisation
    case phone
    case mail
    case theme
    case captcha
    case detail
    case attach
    case done
}

enum FeedBackCellIncomeData {
    case name(with: String?)
    case lastName(with: String?)
    case middleName(with: String?)
    case organisation(with: Organisation?)
    case phone(with: String?)
    case mail(with: String?)
    case theme(with: FeedbackTheme?)
    case captcha(id: String?, text: String?)
    case detail(with: String?)
    case attach(with: [FeedBackAttachModel])
    case done
}

final class CellSource {
    let title: String
    let cellType: UITableViewCell.Type
    var initialData: String?
    var type: StaticCellType
    let cell: UITableViewCell
    init(title: String, cellType: UITableViewCell.Type, type: StaticCellType, cell: UITableViewCell) {
        self.title = title
        self.cellType = cellType
        self.type = type
        self.cell = cell
    }
}
