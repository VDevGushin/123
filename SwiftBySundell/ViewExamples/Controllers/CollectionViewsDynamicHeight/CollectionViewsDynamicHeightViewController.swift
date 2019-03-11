//
//  CollectionViewsDynamicHeightViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class CollectionViewsDynamicHeightViewController: CoordinatorViewController {
    @IBOutlet private weak var contentTableView: UITableView!
    private let logger: Logger
    var arr = ["Basic Operators", "Strings and Characters", "Collection Types", "Control Flow", "Structures and Classes", "Optional Chaining", "Closures", "Automatic Reference Counting", "Advanced Operators", "Access Control", "Memory Safety", "Generics", "Protocols", "Extensions", "Type Casting", "Nested Types", "Error Handling", "Deinitialization"]

    init(logger: Logger,
         navigator: AppCoordinator,
         title: String,
         nibName: String,
         bundle: Bundle?) {
        self.logger = logger //DI
        super.init(navigator: navigator,
                   title: title,
                   nibName: nibName,
                   bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentTableView.dataSource = self
        self.contentTableView.register(UINib.init(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentTableViewCell")
    }
}


extension CollectionViewsDynamicHeightViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as! ContentTableViewCell
        cell.configure(with: self.arr)
        return cell
    }
}
