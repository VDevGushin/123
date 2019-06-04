//
//  RootContentTableViewCell.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 12/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class RootContentTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: DynamicHeightTableView!
    var dataSource = [String]()

    func configure(with dataSource: [String]) {
        self.dataSource = dataSource
        self.table?.reloadData()
        self.table?.layoutIfNeeded()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(UINib.init(nibName: "DemoContentTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DemoContentTableViewCell
        cell.lllll.text = self.dataSource[indexPath.row]
        return cell
    }
}
