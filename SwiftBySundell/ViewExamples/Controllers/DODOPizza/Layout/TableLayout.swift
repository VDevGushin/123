//
//  TableLayout.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class TableLayout: UICollectionViewLayout {
    var itemSize: CGSize = .zero {
        didSet { invalidateLayout() }
    }

    private let section = 0
    private var cache = TableLayoutCache.zero

    override var collectionViewContentSize: CGSize {
        return self.cache.contentSize
    }

    // prepare вызывает расчёт всех фреймов.
    override func prepare() {
        super.prepare()

        let numberOfItems = collectionView!.numberOfItems(inSection: self.section)
        self.cache = TableLayoutCache(itemSize: itemSize, collectionWidth: collectionView!.bounds.width)
        self.cache.recalculateDefaultFrames(numberOfItems: numberOfItems)
    }

    //layoutAttributesForElements(in:) отфильтрует фреймы.
    //Если фрейм пересекается с видимой областью, то значит ячейку нужно отобразить: рассчитать все атрибуты и вернуть её в массиве видимых ячеек.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let indexes = cache.visibleRows(in: rect)

        let cells: [UICollectionViewLayoutAttributes]? = indexes.compactMap { row in
            let path = IndexPath(row: row, section: self.section)
            let attributes = layoutAttributesForItem(at: path)
            return attributes
        }

        return cells
    }

    //рассчитывает атрибуты для одной ячейки.
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = cache.defaultCellFrame(atRow: indexPath.row)
        return attributes
    }
}
