//
//  CustomCollectionViewFlowLayoutViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09/08/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayoutViewController: CoordinatorViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataSource = [CustomCollectionViewFlowCellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CustomCollectionViewFlowLayoutCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewFlowLayoutCollectionViewCell.reuseId)
        let l = PinterestLayout()
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        addData()
    }

    private func addData() {
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        dataSource.append(CustomCollectionViewFlowCellModel(title: "test1", image: nil))
        self.collectionView.reloadData()
    }
}

extension CustomCollectionViewFlowLayoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewFlowLayoutCollectionViewCell.reuseId, for: indexPath) as! CustomCollectionViewFlowLayoutCollectionViewCell
        cell.setup(with: self.dataSource[indexPath.row])
        return cell
    }
}

extension CustomCollectionViewFlowLayoutViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat.random(in: 200...600)
    }
}
