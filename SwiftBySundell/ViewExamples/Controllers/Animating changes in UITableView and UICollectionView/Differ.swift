//
//  Differ.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 14/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Differ

extension UICollectionView {
    func reloadChanges<T: Collection>(from old: T, to new: T) where T.Element: Equatable {
        animateItemChanges(oldData: old, newData: new)
    }
}

extension UITableView {
    func reloadChanges<T: Collection>(from old: T, to new: T) where T.Element: Equatable {
        animateRowChanges(oldData: old, newData: new)
    }
}
