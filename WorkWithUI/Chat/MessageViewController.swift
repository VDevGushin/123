//
//  MessageViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class MessageViewController: ChatBaseViewController, IPullToRefresh {
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageTable: UITableView!
    @IBOutlet private weak var sendBackground: ShadowView!
    @IBOutlet private weak var newMessageText: UITextField!
    @IBOutlet private weak var sendButton: UIButton!

    private let chat: Chat
    private let messagesWorker: ChatMessagesWorker
    private var source = [Message]()
    private var newMessage: NewMessage?

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: ChatCoordinator, chat: Chat) {
        self.chat = chat
        self.messagesWorker = ChatMessagesWorker(chatId: self.chat.id)
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: chat.name ?? "чат", nibName: String(describing: MessageViewController.self), bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesWorker.delegate = self
        self.getMessages()
        self.messagesWorker.startWork()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: self.view.window)
    }

    override func buildUI() {
        //table view delegate
        ChatStyle.tableView(self.messageTable, self, MessageTableViewCell.self)
        ChatStyle.sendButton(self.sendButton)
        ChatStyle.defaultBackground(self.sendBackground)

        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(MessageViewController.keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: self.view.window)
        notifier.addObserver(self,
                             selector: #selector(MessageViewController.keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: self.view.window)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @IBAction func sendMessageHandler(_ sender: Any) {
        self.dismissKeyboard()
        self.messagesWorker.sendNewMessage(text: self.newMessageText.text) { [weak self] result in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                if case Result.result(let value) = result {
                    if wSelf.source.appendMessage(value) {
                        wSelf.updateTableWithNewMessage()
                        wSelf.messageTable.scrollToBottom()
                        wSelf.newMessageText.text = String()
                    }
                }
            }
        }
    }

    fileprivate func updateTableWithNewMessage() {
        if self.source.count > 0 {
            self.messageTable.beginUpdates()
            self.messageTable.insertRows(at: [IndexPath(row: self.source.count - 1, section: 0)], with: .automatic)
            self.messageTable.endUpdates()
        }
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getMessages()
        //self.refresh()
        refreshControl.endRefreshing()
    }

    fileprivate func refresh() {
        self.source.removeAll()
        self.messagesWorker.refresh()
    }

    fileprivate func getMessages() {
        self.messagesWorker.getChatMessages()
    }
}

// MARK: - Messagesworker Delegate
extension MessageViewController: MessagesWorkerDelegate {
    func sourceCount(perPage: Int) -> Int {
        if self.source.count == 0 {
            return 1
        }
        let pages = Int(self.source.count / perPage)
        return pages + 1
    }

    func sourceChanged(isFirstTime: Bool, source: Result<[Message]>) {
        DispatchQueue.main.async {
            if case Result.result(let value) = source {
                if isFirstTime {
                    self.source = value
                    self.messageTable.reloadData()
                    self.messageTable.scrollToBottom(animated: false)
                } else {
                    for element in value.reversed() {
                        if self.source.insertMessage(element, at: 0) {
                            self.messageTable.beginUpdates()
                            self.messageTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                            self.messageTable.endUpdates()
                        }
                    }
                }
            }
        }
    }

    func receiveNewMessages(source: Result<[Message]>) {
        DispatchQueue.main.async {
            if case Result.result(let value) = source {
                for i in 0..<value.count {
                    if self.source.appendMessage(value[i]) {
                        self.updateTableWithNewMessage()
                    }
                }
            }
        }
    }
}

// MARK: - Table view delegate
extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: MessageTableViewCell.self, indexPath: indexPath)!
        cell.setMessage(message: self.source[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Work with keyboard
fileprivate extension MessageViewController {
    @objc func keyboardWillShowNotification(_ sender: NSNotification) {
        adjustingHeight(true, notification: sender)
    }

    @objc func keyboardWillHideNotification(_ sender: NSNotification) {
        adjustingHeight(false, notification: sender)
    }

    private func adjustingHeight(_ show: Bool, notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrameBeginUserInfoKey = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
            let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }

        let keyboardFrame: CGRect = keyboardFrameBeginUserInfoKey.cgRectValue

        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if !show {
                self.keyboardConstraint.constant = 0.0
            } else {
                self.keyboardConstraint.constant += keyboardFrame.height
            }
        })
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Class helpers
fileprivate extension Array where Element == Message {
    @discardableResult
    mutating func appendMessage(_ newElement: Message) -> Bool {
        if !self.contains(newElement) {
            self.append(newElement)
            return true
        }
        return false
    }

    @discardableResult
    mutating func insertMessage(_ newElement: Message, at: Int) -> Bool {
        if !self.contains(newElement) {
            self.insert(newElement, at: 0)
            return true
        }
        return false
    }
}

