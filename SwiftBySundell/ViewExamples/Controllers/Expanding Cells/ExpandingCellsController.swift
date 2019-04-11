//
//  ExpandingCellsController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class ExpandingCellsController: CoordinatorViewController {
    @IBOutlet private weak var collection: UICollectionView!

    private let inspirations = Inspiration.allInspirations()
    private let colors = UIColor.palette()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }

        collection.collectionViewLayout = UltravisualLayout()
        collection?.backgroundColor = .clear
        collection.register(UINib(nibName: "InspirationCell", bundle: nil), forCellWithReuseIdentifier: InspirationCell.reuseIdentifier)
        collection.delegate = self
        collection.dataSource = self

        self.collection.reloadData()
    }
}

extension ExpandingCellsController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inspirations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InspirationCell.reuseIdentifier, for: indexPath
        ) as! InspirationCell
        cell.contentView.backgroundColor = colors[indexPath.item]
        cell.inspiration = self.inspirations[indexPath.item]
        return cell
    }
}

