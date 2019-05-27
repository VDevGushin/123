//
//  MainViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import Lottie
import os

private let subsystem = "com.vlad.Test"
struct Log {
    static let table = OSLog(subsystem: subsystem, category: "table")
}

final class MainViewController: CoordinatorViewController {
    @IBOutlet private weak var menuTable: UITableView!
    private var dataSource =
        [
            AppCoordinator.Destination.tinder,
            AppCoordinator.Destination.cardGame,
            AppCoordinator.Destination.timer,
            AppCoordinator.Destination.dodo,
            //AppCoordinator.Destination.lottieView,
            AppCoordinator.Destination.promiseKit,
            AppCoordinator.Destination.swinject,
            AppCoordinator.Destination.childVC,
            AppCoordinator.Destination.dynamicCollection,
            AppCoordinator.Destination.rootContent,
            AppCoordinator.Destination.diff,
            AppCoordinator.Destination.diffCollectionLayout,
            AppCoordinator.Destination.expandingCellsController,
            AppCoordinator.Destination.stickyHeader]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTable.dataSource = self
        self.menuTable.delegate = self
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        let source = dataSource[indexPath.row]

        cell!.textLabel?.text = source.title

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let source = dataSource[indexPath.row]
        os_log("Can't build a valid URL. Returning error.",
            log: Log.table, type: .error)
        self.navigator.navigate(to: source)
    }
}
