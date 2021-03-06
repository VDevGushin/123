//
//  PinterestLayout.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09/08/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

final class PinterestLayout: UICollectionViewFlowLayout {
    weak var delegate: PinterestLayoutDelegate?

    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6
    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override init() {
        super.init()
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = .vertical
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        var column = 0

        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 0.0

            let height = cellPadding * 2 + photoHeight

            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)

            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
