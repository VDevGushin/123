//
//  SourcesTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 05/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class SourcesTableViewController: UITableViewController {
    private var webService: Webservice!
    private var sourceListViewModel: SourceListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func updateUI() {
        self.webService = Webservice()
        self.sourceListViewModel = SourceListViewModel(webService: self.webService)
    }
}
