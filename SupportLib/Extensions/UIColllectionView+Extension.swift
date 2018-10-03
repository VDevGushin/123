//
//  UIColllectionView+Extension.swift
//  MyWork
//
//  Created by Vladislav Gushin on 28/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit


extension UICollectionView {
    func register(_ cellType: UICollectionViewCell.Type) {
        let id = String(describing: cellType)
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: id)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath)
        return cell as? T
    }

}
