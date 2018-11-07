//
//  FeedBackSearchViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

protocol FeedBackSearchViewControllerDelegate: class {
    func selectSource(selected: ISource)
}

class FeedBackSearchViewController: FeedBackBaseViewController {
    weak var delegate: FeedBackSearchViewControllerDelegate?
    @IBOutlet private weak var keyBoardView: UIView!
    @IBOutlet private weak var contentTable: UITableView!

    private lazy var resultSearchController = UISearchController(searchResultsController: nil)
    private var source = [ISource]()
    private var filteredSource = [ISource]()

    private var worker: IFeedBackWorker

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: FeedBackNavigator, title: String, worker: IFeedBackWorker) {
        self.worker = worker
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: title, nibName: String(describing: FeedBackSearchViewController.self), bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.worker.delegate = self

        self.worker.refresh()
    }

    override func buildUI() {
        self.keyBoardView.isHidden = true
        FeedBackStyle.serachController(self.resultSearchController, self)
        FeedBackStyle.tableView(self.contentTable, self, [SourceTableViewCell.self])
        self.contentTable.allowsMultipleSelection = true
        self.contentTable.tableHeaderView = resultSearchController.searchBar

        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(FeedBackSearchViewController.keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: self.view.window)
        notifier.addObserver(self,
                             selector: #selector(FeedBackSearchViewController.keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: self.view.window)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.keyBoardView.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        if let text = resultSearchController.searchBar.text, !text.isEmpty {
            self.resultSearchController.searchBar.endEditing(true)
        } else {
            resultSearchController.isActive = false
        }
    }

    @objc func keyboardWillShowNotification(_ sender: NSNotification) {
        self.keyBoardView.isHidden = false
    }

    @objc func keyboardWillHideNotification(_ sender: NSNotification) {
        self.keyBoardView.isHidden = true
    }
}

extension FeedBackSearchViewController: IPullToRefresh, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 1 {
            self.filteredSource.removeAll()
            self.filteredSource = source.filter { element in
                guard let innerTitle = element.innerTitle else { return false }
                let lower = innerTitle.lowercased()
                let text = text.lowercased()
                return lower.contains(text)
            }
            self.contentTable.reloadData()
        } else {
            self.filteredSource.removeAll()
            self.filteredSource = self.source
            self.contentTable.reloadData()
        }
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.worker.refresh()
        refreshControl.endRefreshing()
    }
}

extension FeedBackSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultSearchController.isActive {
            let element = self.filteredSource[indexPath.item]
            self.delegate?.selectSource(selected: element)
            print(element.innerTitle ?? "...")
        } else {
            let element = self.source[indexPath.item]
            self.delegate?.selectSource(selected: element)
            print(element.innerTitle ?? "...")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredSource.count
        } else {
            return self.source.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: SourceTableViewCell.self, indexPath: indexPath)!
        if self.resultSearchController.isActive {
            cell.setSource(with: self.filteredSource[indexPath.item])
        } else {
            cell.setSource(with: self.source[indexPath.item])
        }
        cell.selectionStyle = .none

        //load next
        if indexPath.row == self.source.count - 1 && !self.resultSearchController.isActive {
            self.worker.execute()
        }
        return cell
    }
}

extension FeedBackSearchViewController: IFeedBackWorkerDelegate {
    func sourceChanged<T>(isFirstTime: Bool, source: T) {
        guard let result = source as? Organisations else { return }
        DispatchQueue.main.async {
            if isFirstTime {
                self.source = result
                self.contentTable.reloadData()
            } else {
                for element in result {
                    self.source.append(element)
                    self.contentTable.beginUpdates()
                    self.contentTable.insertRows(at: [IndexPath(row: self.source.count - 1, section: 0)], with: .automatic)
                    self.contentTable.endUpdates()
                }
            }
        }
    }

    func sourceError(with: Error) {
        print(with.localizedDescription)
    }
}
