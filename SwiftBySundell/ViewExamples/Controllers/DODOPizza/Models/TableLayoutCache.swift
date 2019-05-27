//
//  TableLayoutCache.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class TableLayoutCache {
    static var zero: TableLayoutCache { return TableLayoutCache(itemSize: .zero, collectionWidth: 0) }
    private let itemSize: CGSize
    private let collectionWidth: CGFloat
    private var defaultFrames = [CGRect]()

    init(itemSize: CGSize, collectionWidth: CGFloat) {
        self.itemSize = itemSize
        self.collectionWidth = collectionWidth
    }

    // MARK: - Calculation
    func recalculateDefaultFrames(numberOfItems: Int) {
        self.defaultFrames = (0..<numberOfItems).map {
            defaultCellFrame(atRow: $0)
        }
    }

    func defaultCellFrame(atRow row: Int) -> CGRect {
        let y = itemSize.height * CGFloat(row)
        let defaultFrame = CGRect(x: 0, y: y,
            width: collectionWidth,
            height: itemSize.height)
        return defaultFrame
    }

    // MARK: - Access
    func visibleRows(in frame: CGRect) -> [Int] {
        return self.defaultFrames
            .enumerated() // Index to frame relation
        .filter { $0.element.intersects(frame) } // Filter by frame
        .map { $0.offset } // Return indexes
    }

    var contentSize: CGSize {
        return CGSize(width: self.collectionWidth, height: self.defaultFrames.last?.maxY ?? 0)
    }
}
