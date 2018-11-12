//
//  CellSource.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 11/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

enum FeedBackCellAction {
    typealias FeedBackHandler = (FeedBackCellIncomeData) -> Void
    case setName(FeedBackHandler)
    case setLastName(FeedBackHandler)
    case setMiddleName(FeedBackHandler)
    case setOrganisation(FeedBackNavigator, FeedBackHandler)
    case setPhone(FeedBackHandler)
    case setMail(FeedBackHandler)
    case setTheme(FeedBackNavigator, FeedBackHandler)
    case setCaptcha(FeedBackHandler)
    case setDetail(FeedBackHandler)
    case done(FeedBackHandler)
    case attach(FeedBackHandler)

    var id: Int {
        switch self {
        case .setName: return StaticCellType.name.rawValue
        case .setLastName: return StaticCellType.lastName.rawValue
        case .setMiddleName: return StaticCellType.middleName.rawValue
        case .setOrganisation: return StaticCellType.organisation.rawValue
        case .setPhone: return StaticCellType.phone.rawValue
        case .setMail: return StaticCellType.mail.rawValue
        case .setTheme: return StaticCellType.theme.rawValue
        case .setCaptcha: return StaticCellType.captcha.rawValue
        case .setDetail: return StaticCellType.detail.rawValue
        case .done: return StaticCellType.done.rawValue
        case .attach: return StaticCellType.attach.rawValue
        }
    }

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
    case attach(with : [FeedBackAttachModel])
    case done
}

final class CellSource {
    let title: String
    let cellType: UITableViewCell.Type
    let action: FeedBackCellAction
    var initialData: String?
    let cell: UITableViewCell
    init(title: String, cellType: UITableViewCell.Type, action: FeedBackCellAction, cell: UITableViewCell) {
        self.title = title
        self.cellType = cellType
        self.action = action
        self.cell = cell
    }
}
