//
//  MessageViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class MessageViewController: ChatBaseViewController {
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

    @IBAction func sendMessageHandler(_ sender: Any) {
        self.dismissKeyboard()
        self.messagesWorker.sendNewMessage(text: self.newMessageText.text) { [weak self] result in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                if case Result.result(let value) = result {
                    wSelf.source.append(value)
                    wSelf.messageTable.beginUpdates()
                    wSelf.messageTable.insertRows(at: [IndexPath(row: wSelf.source.count - 1, section: 0)], with: .automatic)
                    wSelf.messageTable.endUpdates()
                    
                    wSelf.messageTable.scrollToBottom()
                    wSelf.newMessageText.text = String()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesWorker.sourceChanged.delegate(to: self) { delegate, result in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .result(let value):
                    if value.isFirstTime {
                        delegate.source = value.source
                        delegate.messageTable.reloadData()
                        delegate.messageTable.scrollToBottom(animated: true)
                    } else {
                        for i in 0..<value.source.count {
                            delegate.source.insert(value.source[i], at: 0)
                            delegate.messageTable.beginUpdates()
                            delegate.messageTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                            delegate.messageTable.endUpdates()
                        }
                    }
                }
            }
        }
        self.getMessages()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: self.view.window)
    }

    override func buildUI() {
        self.messageTable.delegate = self
        self.messageTable.dataSource = self
        self.messageTable.separatorStyle = .none

        self.messageTable.register(MessageTableViewCell.self)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MessageViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.messageTable.addSubview(refreshControl)

        refreshControl.tintColor = ChatResources.styleColor
        sendBackground.backgroundColor = ChatResources.styleColor
        self.messageTable.backgroundColor = ChatResources.whiteColor
        self.sendButton.backgroundColor = ChatResources.styleColor
        self.sendButton.tintColor = ChatResources.whiteColor


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
}

extension MessageViewController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.messagesWorker.refresh()
        //self.getMessages()
        refreshControl.endRefreshing()
    }

    fileprivate func getMessages() {
        self.messagesWorker.getChatMessages()
    }
}

// MARK: - Tablve view delegate
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
