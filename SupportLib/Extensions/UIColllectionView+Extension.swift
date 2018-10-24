//
//  UIColllectionView+Extension.swift
//  MyWork
//
//  Created by Vladislav Gushin on 28/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public extension UICollectionView {
    public func registerWithNib(_ cellType: UICollectionViewCell.Type) {
        let id = String(describing: cellType)
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: id)
    }

    public func registerWithClass(_ cellType: UICollectionViewCell.Type) {
        let id = String(describing: cellType)
        self.register(cellType, forCellWithReuseIdentifier: id)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath)
        return cell as? T
    }
}
