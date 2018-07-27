//
//  UITableView+Ex.swift
//  MyWork
//
//  Created by Vladislav Gushin on 26/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ cellType: UITableViewCell.Type) {
        let id = String(describing: cellType)
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellReuseIdentifier: id)
    }

    func registerFooterHeader(_ type: UITableViewHeaderFooterView.Type) {
        let id = String(describing: type)
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: id)
    }

    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(type: T.Type) -> T? {
        let id = String(describing: type)
        let view = self.dequeueReusableHeaderFooterView(withIdentifier: id)
        return view as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath)
        return cell as? T
    }

    func sizeHeaderToFit() {
        if let headerView = self.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            self.tableHeaderView = headerView
        }
    }

    func sizeFooterToFit() {
        if let footerView = self.tableFooterView {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            let height = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = footerView.frame
            frame.size.height = height
            footerView.frame = frame
            self.tableFooterView = footerView
        }
    }
}
