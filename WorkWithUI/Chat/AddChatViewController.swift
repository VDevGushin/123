//
//  AddChatViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 01/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class AddChatViewController: ChatBaseViewController, IPullToRefresh {
    @IBOutlet private weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentTable: UITableView!
    @IBOutlet private weak var backView: ShadowView!
    @IBOutlet private weak var chatName: UITextField!
    @IBOutlet private weak var createButton: UIButton!

    @IBOutlet private weak var keyBoardView: UIView!

    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    private lazy var profileWorker: ProfileWorker = ProfileWorker()
    private lazy var chatWorker = ChatsWorker()
    private lazy var searchBar = UISearchBar(frame: CGRect.zero)
    private lazy var resultSearchController = UISearchController(searchResultsController: nil)

    private var source = [Profile]()
    private var filteredSource = [Profile]()
    private var selectedItems = Set<Profile>()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: ChatCoordinator) {
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: "Создать чат", nibName: String(describing: AddChatViewController.self), bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileWorker.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.profileWorker.refresh()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.resultSearchController.view.isHidden = true
        self.resultSearchController.isActive = false
        super.viewWillDisappear(animated)
    }

    override func buildUI() {
        ChatStyle.serachController(self.resultSearchController, self)
        ChatStyle.sendButton(self.createButton)
        ChatStyle.defaultBackground(self.backView)
        ChatStyle.tableView(self.contentTable, self, [ProfileTableViewCell.self])
        self.contentTable.allowsMultipleSelection = true
        self.contentTable.tableHeaderView = resultSearchController.searchBar

        self.keyBoardView.isHidden = true

        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(AddChatViewController.keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: self.view.window)
        notifier.addObserver(self,
                             selector: #selector(AddChatViewController.keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: self.view.window)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        keyBoardView.addGestureRecognizer(tap)
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.profileWorker.refresh()
        refreshControl.endRefreshing()
    }

    @IBAction func addChat(_ sender: Any) {
        let ids = self.selectedItems.map { $0.id }
        guard ids.count > 0 else { return }

        self.chatWorker.createChat(with: NewChat(name: self.chatName.text, profileIds: ids, authorProfileId: ChatResources.pid)) { source in
            DispatchQueue.main.async {
                if case Result.result(let value) = source {

                }
            }
        }
    }
}

// MARK: - UISearchResults delegate
extension AddChatViewController: UISearchResultsUpdating, ProfileWorkerDelegate {
    func sourceChanged(isFirstTime: Bool, source: Result<[Profile]>) {
        DispatchQueue.main.async {
            if case Result.result(let value) = source {
                self.source = value
                if isFirstTime {
                    self.contentTable.reloadData()
                }
            }
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if text.count > 3 {
            self.selectedItems.removeAll()
            self.filteredSource.removeAll()
            self.filteredSource = source.filter {
                if let user = $0.user {
                    if let firstName = user.firstName, firstName.lowercased().contains(text.lowercased()) {
                        return true
                    }
                    if let middleName = user.middleName, middleName.lowercased().contains(text.lowercased()) {
                        return true
                    }
                    if let middleName = user.middleName, middleName.lowercased().contains(text.lowercased()) {
                        return true
                    }
                }
                return false
            }
            self.contentTable.reloadData()
        } else {
            self.selectedItems.removeAll()
            self.filteredSource.removeAll()
            self.filteredSource = self.source
            self.contentTable.reloadData()
        }
        self.createButton?.isEnabled = !self.selectedItems.isEmpty
    }
}

// MARK: - Table view delegate
extension AddChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultSearchController.isActive {
            selectedItems.insert(filteredSource[indexPath.row])
        } else {
            selectedItems.insert(source[indexPath.row])
        }
        createButton?.isEnabled = !self.selectedItems.isEmpty
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if resultSearchController.isActive {
            selectedItems.remove(filteredSource[indexPath.row])
        } else {
            selectedItems.remove(source[indexPath.row])
        }
        createButton?.isEnabled = !self.selectedItems.isEmpty
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filteredSource.count
        } else {
            return source.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ProfileTableViewCell.self, indexPath: indexPath)!
        if resultSearchController.isActive {
            cell.setProfile(with: self.filteredSource[indexPath.item])
        } else {
            cell.setProfile(with: self.source[indexPath.item])
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Work with keyboard
fileprivate extension AddChatViewController {
    @objc func keyboardWillShowNotification(_ sender: NSNotification) {
        self.adjustingHeight(true, notification: sender)
    }

    @objc func keyboardWillHideNotification(_ sender: NSNotification) {
        self.adjustingHeight(false, notification: sender)
    }

    private func adjustingHeight(_ show: Bool, notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrameBeginUserInfoKey = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }

        let keyboardFrame: CGRect = keyboardFrameBeginUserInfoKey.cgRectValue

        var safeArea: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            safeArea = window?.safeAreaInsets.bottom ?? 0.0
        }

        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if !show {
                self.keyBoardView.isHidden = true
                self.keyboardConstraint.constant = 0.0
            } else {
                self.keyBoardView.isHidden = false
                if !self.chatName.isEditing {
                    safeArea += self.backViewHeight.constant
                    self.keyBoardView.isHidden = true
                }
                self.keyboardConstraint.constant = keyboardFrame.height - safeArea
            }
        })
    }

    @objc func dismissKeyboard() {
        self.keyBoardView.isHidden = true
        view.endEditing(true)
    }
}
