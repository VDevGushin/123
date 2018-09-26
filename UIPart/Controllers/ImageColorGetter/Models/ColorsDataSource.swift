//
//  ColorsDataSource.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    typealias DataSource = [Model]

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    var models: DataSource

    init(models: DataSource,
         reuseIdentifier: UITableViewCell.Type,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = String(describing: reuseIdentifier)
        self.cellConfigurator = cellConfigurator
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(model, cell)
        return cell
    }
}
