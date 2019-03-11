//
//  ContentTableViewCell.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    @IBOutlet weak var coll: DynamicHeightCollectionView!
    var dataSource = [String]()

    func configure(with dataSource: [String]) {
        self.dataSource = dataSource
        self.coll?.reloadData()
        self.coll?.layoutIfNeeded()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.coll.dataSource = self
        self.coll.delegate = self
        self.coll.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.textLabel.text = self.dataSource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.dataSource[indexPath.row]
        let cellWidth = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12.0)]).width + 30.0
        return CGSize(width: cellWidth, height: 30.0)
    }
}
