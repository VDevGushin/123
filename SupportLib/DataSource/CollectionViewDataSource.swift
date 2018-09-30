//
//  CollectionViewDataSource.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class CollectionViewDataSource<Model>: NSObject, UICollectionViewDataSource {
    typealias CellConfigurator = (Model, UICollectionViewCell) -> Void
    typealias DataSource = [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    var models: DataSource
    
    init(models: DataSource,
         reuseIdentifier: UICollectionViewCell.Type,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = String(describing: reuseIdentifier)
        self.cellConfigurator = cellConfigurator
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(model, cell)
        return cell
    }
}
