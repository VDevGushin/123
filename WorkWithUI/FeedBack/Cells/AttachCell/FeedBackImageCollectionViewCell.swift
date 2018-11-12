//
//  FeedBackImageCollectionViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 12/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct FeedBackAttachModel: Hashable {
    let image: UIImage
    let id: ObjectIdentifier
    init(image: UIImage) {
        self.image = image
        self.id = ObjectIdentifier(self.image)
    }
}

class FeedBackImageCollectionViewCell: UICollectionViewCell {
    private var deleteHandler: ((ObjectIdentifier) -> Void)?
    private var model: FeedBackAttachModel!
    @IBOutlet private weak var fileImage: UIImageView!

    func configure(with model: FeedBackAttachModel, deleteHandler: @escaping (ObjectIdentifier) -> Void) {
        self.deleteHandler = deleteHandler
        self.model = model
        self.fileImage.image = model.image
    }

    @IBAction private func deleteAction(_ sender: Any) {
        self.deleteHandler?(self.model.id)
    }
}
