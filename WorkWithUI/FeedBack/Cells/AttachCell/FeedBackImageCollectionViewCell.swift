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
    let data: Data
    let bytes: [UInt8]
    let id: ObjectIdentifier
    var size: Int {
        return self.bytes.count
    }
    init(image: UIImage, data: Data) {
        self.data = data
        self.image = image
        self.id = ObjectIdentifier(self.image)
        self.bytes = [UInt8](data)
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
