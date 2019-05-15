//
//  Registerable Views.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 18/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

enum RegisterableView {
    case nib(NSObject.Type)
    case `class`(NSObject.Type)
}

extension RegisterableView {
    var nib: UINib? {
        switch self {
        case let .nib(cellClass):
            return UINib(nibName: String(describing: cellClass), bundle: nil)
        default:
            return nil
        }
    }

    var cellClass: AnyClass? {
        switch self {
        case let .class(cellClass):
            return cellClass
        default:
            return nil
        }
    }

    var identifier: String {
        switch self {
        case let .nib(cellClass):
            return cellClass.identifier()
        case let .class(cellClass):
            return cellClass.identifier()
        }
    }
}

protocol ClassIdentifiable {
    static func identifier() -> String
}

extension NSObject: ClassIdentifiable {
    static func identifier() -> String {
        return String(describing: self)
    }
}

protocol CollectionView {
    func register(cell: RegisterableView)
    func register(header: RegisterableView)
    func register(footer: RegisterableView)
}

extension CollectionView {
    func register(cells: [RegisterableView]) {
        cells.forEach(register(cell:))
    }

    func register(headers: [RegisterableView]) {
        headers.forEach(register(header:))
    }

    func register(footers: [RegisterableView]) {
        footers.forEach(register(footer:))
    }
}

extension UITableView: CollectionView {
    func register(cell: RegisterableView) {
        switch cell {
        case .nib:
            register(cell.nib, forCellReuseIdentifier: cell.identifier)
        case .class:
            register(cell.cellClass, forCellReuseIdentifier: cell.identifier)
        }
    }

    func register(header: RegisterableView) {
        switch header {
        case .nib:
            register(header.nib, forHeaderFooterViewReuseIdentifier: header.identifier)
        case .class:
            register(header.cellClass, forHeaderFooterViewReuseIdentifier: header.identifier)
        }
    }

    func register(footer: RegisterableView) {
        register(header: footer)
    }
}

class MyTableViewCell: UITableViewCell { }
class NibTableViewCell: UITableViewCell { }

class TestVC: UIViewController {
    var tableView: UITableView!

    func test() {
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: String(describing: MyTableViewCell.self))

        tableView.register(UINib(nibName: String(describing: NibTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NibTableViewCell.self))

        tableView.register(cells: [.nib(MyTableViewCell.self), .class(NibTableViewCell.self)])
    }
}
