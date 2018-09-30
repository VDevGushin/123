//
//  TableViewDataSource.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public final class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    public typealias CellConfigurator = (Model, UITableViewCell) -> Void
    public typealias DataSource = [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    public var models: DataSource
    
    public init(models: DataSource,
         reuseIdentifier: UITableViewCell.Type,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = String(describing: reuseIdentifier)
        self.cellConfigurator = cellConfigurator
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(model, cell)
        return cell
    }
}
