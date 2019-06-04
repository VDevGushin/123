//
//  SimpleCellLayout.swift
//  DodoPizza
//
//  Created by Mikhail Rubanov on 14/11/2018.
//  Copyright © 2018 Dodo Pizza. All rights reserved.
//

import UIKit

class TableLayout: UICollectionViewLayout {
    private let section = 0
    var cache = TableLayoutCache.zero
    var orientation: PizzaHalfOrientation = .left

    var itemSize: CGSize = .zero {
        didSet {
            invalidateLayout()
        }
    }

    override var collectionViewContentSize: CGSize {
        return cache.contentSize
    }

    override func prepare() {
        super.prepare()
        let numberOfItems = self.collectionView!.numberOfItems(inSection: self.section)
        self.cache = TableLayoutCache(itemSize: self.itemSize,
            collectionWidth: collectionView!.bounds.width)
        cache.recalculateDefaultFrames(numberOfItems: numberOfItems)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let indexes = self.cache.visibleRows(in: rect)

        let attributes: [UICollectionViewLayoutAttributes] = indexes.compactMap { row in
            let path = IndexPath(row: row, section: section)
            let attributes = self.layoutAttributesForItem(at: path)
            return attributes
        }
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = self.cache.defaultCellFrame(atRow: indexPath.row)
        return attributes
    }
}
