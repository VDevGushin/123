//
//  SelfSizeCollectionViewCell.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 02/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class SelfSizeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    // Note: must be strong
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
        didSet { self.maxWidthConstraint.isActive = false }
    }

    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = self.maxWidth else { return }
            self.maxWidthConstraint.isActive = true
            self.maxWidthConstraint.constant = maxWidth
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.contentView.leftAnchor.constraint(equalTo: leftAnchor),
            self.contentView.rightAnchor.constraint(equalTo: rightAnchor),
            self.contentView.topAnchor.constraint(equalTo: topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
