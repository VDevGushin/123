//
//  CapturingObjectsSwift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
fileprivate class ListViewModel {
    func observeNumberOfItemsChanged(_ then: () -> Void) {
        then()
    }
}

// MARK: - Capturing & retain cycles
fileprivate class ListViewController: UITableViewController {
    private let viewModel: ListViewModel
    weak var table: UITableView?

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.viewModel.observeNumberOfItemsChanged { [weak self] in
            self?.table?.reloadData()
        }

        self.viewModel.observeNumberOfItemsChanged { [weak self] in
            guard let wSelf = self else { return }
            wSelf.table?.reloadData()
        }

        let context = (viewModel: self)
        self.viewModel.observeNumberOfItemsChanged {
            context.viewModel.table?.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
