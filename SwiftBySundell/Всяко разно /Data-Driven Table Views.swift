//
//  Data-Driven Table Views.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 03/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

struct SectionDataDriven<Item> {
    var items: [Item]
}

struct DataSourceDataDriven<Item> {
    var sections: [SectionDataDriven<Item>]

    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfItems(in section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return sections[section].items.count
    }

    func item(at indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.row]
    }
}

protocol ConfiguratorTypeDataDriven {
    associatedtype Item
    associatedtype Cell: UITableViewCell

    func reuseIdentifier(for item: Item, indexPath: IndexPath) -> String
    func configure(cell: Cell, item: Item, tableView: UITableView, indexPath: IndexPath) -> Cell
    func registerCells(in tableView: UITableView)
}

extension ConfiguratorTypeDataDriven {
    func configuredCell(for item: Item, tableView: UITableView, indexPath: IndexPath) -> Cell {
        let reuseIdentifier = self.reuseIdentifier(for: item, indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        return self.configure(cell: cell, item: item, tableView: tableView, indexPath: indexPath)
    }
}

struct ConfiguratorDataDriven<Item, Cell: UITableViewCell>: ConfiguratorTypeDataDriven {
    typealias CellConfigurator = (Cell, Item, UITableView, IndexPath) -> Cell

    private let configurator: CellConfigurator

    private let reuseIdentifier = "\(Cell.self)"

    init(configurator: @escaping CellConfigurator) {
        self.configurator = configurator
    }

    func reuseIdentifier(for item: Item, indexPath: IndexPath) -> String {
        return self.reuseIdentifier
    }

    func configure(cell: Cell, item: Item, tableView: UITableView, indexPath: IndexPath) -> Cell {
        return configurator(cell, item, tableView, indexPath)
    }

    func registerCells(in tableView: UITableView) {
        if let path = Bundle.main.path(forResource: "\(Cell.self)", ofType: "nib"),
            FileManager.default.fileExists(atPath: path) {
            let nib = UINib(nibName: "\(Cell.self)", bundle: .main)
            tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        } else {
            tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        }
    }
}

class PluginTableViewController<Item, Cell: UITableViewCell>: UITableViewController {

    let dataSource: DataSourceDataDriven<Item>
    let configurator: ConfiguratorDataDriven<Item, Cell>

    init(dataSource: DataSourceDataDriven<Item>, configurator: ConfiguratorDataDriven<Item, Cell>) {
        self.dataSource = dataSource
        self.configurator = configurator
        super.init(nibName: nil, bundle: nil)
        configurator.registerCells(in: tableView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource.item(at: indexPath)
        return configurator.configuredCell(for: item, tableView: tableView, indexPath: indexPath)
    }
}

class DataDrivenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    func setupTable() {
        let section0 = SectionDataDriven(items: ["A", "B", "C"])
        let section1 = SectionDataDriven(items: ["1", "2", "3"])
        let dataSource = DataSourceDataDriven(sections: [section0, section1])

        let configurator = ConfiguratorDataDriven { (cell, model: String, tableView, indexPath) -> UITableViewCell in
            cell.textLabel?.text = model
            return cell
        }

        let table = PluginTableViewController(dataSource: dataSource, configurator: configurator)

        self.add(child: table, container: view)
    }

    func add(child: UIViewController, container: UIView, configure: (_ childView: UIView) -> Void = { _ in }) {
        addChild(child)
        container.addSubview(child.view)
        configure(child.view)
        child.didMove(toParent: self)
    }
}
