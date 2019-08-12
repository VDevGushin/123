//
//  CustomCollectionViewFlowLayoutCollectionViewCell.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09/08/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

struct CustomCollectionViewFlowCellModel {
    let title: String
    let image: UIImage?
}

class CustomCollectionViewFlowLayoutCollectionViewCell: UICollectionViewCell {
    static let reuseId = "CustomCollectionViewFlowLayoutCollectionViewCell"
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(with: CustomCollectionViewFlowCellModel) {
        self.title.text = with.title
        self.imageView.image = with.image
    }
}
