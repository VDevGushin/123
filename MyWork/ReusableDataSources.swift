//
//  ReusableDataSources.swift
//  MyWork
//
//  Created by Vladislav Gushin on 17/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//MARK: - Moving out of view controllers
fileprivate struct Message {
    let title: String
    let preview: String
}

private final class TestDataSourceViewController: UIViewController, UITableViewDataSource {
    let messages = [Message]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath)
        cell.textLabel?.text = message.title
        cell.detailTextLabel?.text = message.preview
        return cell
    }
}


//MARK: - Using data source
fileprivate final class MessageListDataSource: NSObject, UITableViewDataSource {
    typealias DataSource = [Message]
    var messages: DataSource

    init(messages: DataSource) {
        self.messages = messages
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath)
        cell.textLabel?.text = message.title
        cell.detailTextLabel?.text = message.preview
        return cell
    }
}

//MARK: - Generalizing
fileprivate enum ReuseIdentifierName: String {
    case test
}

fileprivate final class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    typealias DataSource = [Model]

    private let reuseIdentifier: ReuseIdentifierName
    private let cellConfigurator: CellConfigurator
    var models: DataSource

    init(models: DataSource,
         reuseIdentifier: ReuseIdentifierName,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier.rawValue, for: indexPath)
        cellConfigurator(model, cell)
        return cell
    }
}

extension TableViewDataSource where Model == Message {
    static func make(for messages: [Message], reuseIdentifier: ReuseIdentifierName = .test) -> Self {
        return self.init(models: messages, reuseIdentifier: reuseIdentifier) { (message, cell) in
            cell.textLabel?.text = message.title
            cell.detailTextLabel?.text = message.preview
        }
    }
}



//Using
private final class TestDataSourceViewControllerWithDataSource: UIViewController {
    var dataSource: TableViewDataSource<Message>?
    @IBOutlet weak var table: UITableView?
    func messagesDidLoad(_ messages: [Message]) {
//        let dataSource = TableViewDataSource(
//            models: messages,
//            reuseIdentifier: ReuseIdentifierName.test
//        ) { message, cell in
//            cell.textLabel?.text = message.title
//            cell.detailTextLabel?.text = message.preview
//        }
        self.dataSource = .make(for: messages)
        // We also need to keep a strong reference to the data source,
        // since UITableView only uses a weak reference for it.
        self.table?.dataSource = dataSource
    }
}

//TODO: - Composing sections
class SectionedTableViewDataSource: NSObject, UITableViewDataSource {
    private let dataSources: [UITableViewDataSource]

    init(dataSources: [UITableViewDataSource]) {
        self.dataSources = dataSources
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        return dataSource.tableView(tableView, numberOfRowsInSection: 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: 0)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}

//Using
private final class TestDataSourceViewControllerWithDataSourceSection: UIViewController {
    var dataSource: SectionedTableViewDataSource?
    @IBOutlet weak var table: UITableView?
    func messagesDidLoad(_ topMessages: [Message] , _ recentContacts: [Message]) {
        self.dataSource = SectionedTableViewDataSource(dataSources: [
            TableViewDataSource<Message>.make(for: recentContacts),
            TableViewDataSource<Message>.make(for: topMessages)
        ])
        self.table?.dataSource = dataSource
    }
}

