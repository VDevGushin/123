//
//  FeedBackSearchViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class FeedBackSearchViewController: FeedBackBaseViewController {
    @IBOutlet private weak var contentTable: UITableView!
    private lazy var resultSearchController = UISearchController(searchResultsController: nil)
    private var source = [ISource]()
    private let worker: IFeedBackWorker

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: FeedBackNavigator, title: String, worker: IFeedBackWorker) {
        self.worker = worker
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: title, nibName: String(describing: FeedBackSearchViewController.self), bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.worker.refresh()
    }

    override func buildUI() {
        FeedBackStyle.serachController(self.resultSearchController, self)
        FeedBackStyle.tableView(self.contentTable, self, [SourceTableViewCell.self])
        self.contentTable.allowsMultipleSelection = true
        self.contentTable.tableHeaderView = resultSearchController.searchBar
    }
}

extension FeedBackSearchViewController: IPullToRefresh, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
    func handleRefresh(_ refreshControl: UIRefreshControl) { }
}

extension FeedBackSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: SourceTableViewCell.self, indexPath: indexPath)!
        cell.setSource(with: self.source[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }
}
