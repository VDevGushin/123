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

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath)
        return cell as? T
    }
}
