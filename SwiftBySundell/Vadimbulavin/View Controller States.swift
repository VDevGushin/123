//
//  View Controller States.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 26/06/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit


struct ItemServiceResult {
}

protocol ItemService {
    func loadItems(completion: @escaping (Swift.Result<[ItemServiceResult], Error>) -> Void)
}

class ChangeStateViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var emptyStateLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var items: [ItemServiceResult] = []

    var itemService: ItemService!

    lazy var state = ChangeState.state(.empty, viewController: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    private func loadData() {
        state = .state(.loading, viewController: self)
        state.enter()
        
        itemService.loadItems { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items) where items.isEmpty:
                self.state = .state(.empty, viewController: self)
            case .success(let items):
                self.state = .state(.showingData(items), viewController: self)
            case .failure(let error):
                self.state = .state(.error(error), viewController: self)
            }
            
            self.state.enter()
        }
    }
}

// MARK: - State classes
class ChangeState {
    weak var viewController: ChangeStateViewController!

    init(viewController: ChangeStateViewController) {
        self.viewController = viewController
    }

    static func state(_ state: Kind, viewController: ChangeStateViewController) -> ChangeState {
        switch state {
        case .showingData(let items):
            return ShowingDataState(items: items, viewController: viewController)
        case .loading:
            return LoadingChangeState(viewController: viewController)
        case .empty:
            return EmptyState(viewController: viewController)
        case .error(let error):
            return ErrorState(error: error, viewController: viewController)
        }
    }

    func enter() {
        viewController.tableView.isHidden = true
        viewController.errorLabel.isHidden = true
        viewController.activityIndicator.isHidden = true
        viewController.activityIndicator.stopAnimating()
        viewController.emptyStateLabel.isHidden = true
    }
}

extension ChangeState {
    enum Kind {
        case loading
        case showingData([ItemServiceResult])
        case empty
        case error(Error)
    }
}

final class ShowingDataState: ChangeState {
    let items: [ItemServiceResult]

    init(items: [ItemServiceResult], viewController: ChangeStateViewController) {
        self.items = items
        super.init(viewController: viewController)
    }

    override func enter() {
        super.enter()
        viewController.items = items
        viewController.tableView.isHidden = false
        viewController.tableView.reloadData()
    }
}

final class LoadingChangeState: ChangeState {
    override func enter() {
        super.enter()
        viewController.emptyStateLabel.isHidden = false
    }
}

final class EmptyState: ChangeState {
    override func enter() {
        super.enter()
        viewController.emptyStateLabel.isHidden = false
    }
}

final class ErrorState: ChangeState {
    let error: Error
    
    init(error: Error, viewController: ChangeStateViewController) {
        self.error = error
        super.init(viewController: viewController)
    }

    override func enter() {
        super.enter()
        viewController.errorLabel.isHidden = false
        viewController.errorLabel.text = error.localizedDescription
    }
}
