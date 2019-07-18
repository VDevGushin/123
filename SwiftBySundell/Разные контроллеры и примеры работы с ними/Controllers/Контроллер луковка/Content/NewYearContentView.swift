//
//  NewYearContentView.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 18/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class NewYearContentView: UIView {

    // MARK: - Public
    var image: UIImage? {
        didSet { imageView.image = image }
    }

    var title: String? {
        didSet { titleLabel.text = title }
    }

    var body: String? {
        didSet { bodyLabel.text = body }
    }

    // MARK: - Images
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Text
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
}
