//
//  HandlingNonOptionalOptionals.swift
//  MyWork
//
//  Created by Vladislav Gushin on 19/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
struct ViewModel {

}

class TableViewController: UIViewController {
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView!)
    }

    func viewModelDidUpdate(_ viewModel: ViewModel) {
        tableView?.reloadData()
    }
}

//MARK: - Update 1
//Being lazy is better than being non-optionally optional

class TableViewControllerUpdate1: UIViewController {
    lazy var tableView: UITableView = UITableView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    func viewModelDidUpdate(_ viewModel: ViewModel) {
        tableView.reloadData()
    }
}

//MARK: - Proper dependency management is better than non-optional optionals
fileprivate class CommentManager {
    func clearCache() { }
}

fileprivate class Comment { }

fileprivate class TestUSer {
    var totalNumberOfComments: Int = 0
    func logOut() { }
}

fileprivate class UserManagerTest {
    private weak var commentManager: CommentManager?
    private let user = TestUSer()

    func userDidPostComment(_ comment: Comment) {
        user.totalNumberOfComments += 1
    }

    func logOutCurrentUser() {
        user.logOut()
        commentManager?.clearCache()
    }
}
