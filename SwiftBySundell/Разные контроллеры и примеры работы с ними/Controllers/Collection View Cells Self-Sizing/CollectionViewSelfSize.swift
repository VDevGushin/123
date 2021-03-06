//
//  CollectionViewSelfSize.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 02/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class CollectionViewSelfSize: CoordinatorViewController {
    struct Item {
        let title: String
    }

    private enum Constants {
        static let spacing: CGFloat = 16
        static let borderWidth: CGFloat = 0.5
        static let reuseID = "SelfSizeCollectionViewCell"
    }

    let items: [Item] = [
        Item(title: "Lorem ipsum dolor sit amet, consectetur"),
        Item(title: "adipiscing elit, sed do eiusmod tempor"),
        Item(title: "incididunt ut labore et dolore magna aliqua"),
        Item(title: "Ut enim ad minim veniam"),
        Item(title: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
        Item(title: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    ]

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "SelfSizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.reuseID)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension CollectionViewSelfSize: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseID, for: indexPath) as! SelfSizeCollectionViewCell

        cell.label.text = items[indexPath.item].title
        cell.layer.borderWidth = Constants.borderWidth
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.maxWidth = collectionView.bounds.width - Constants.spacing
        return cell
    }
}
