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
    @IBOutlet private weak var messageTable: UITableView!
    @IBOutlet private weak var sendBackground: ShadowView!
    @IBOutlet private weak var newMessageText: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    
    private let chat: Chat
    private let messagesLoader: ChatMessagesLoader
    private var source = [Message]()

    init(navigator: ChatCoordinator, chat: Chat) {
        self.chat = chat
        self.messagesLoader = ChatMessagesLoader(chatId: self.chat.id)
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: chat.name ?? "чат", nibName: String(describing: MessageViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesLoader.sourceChanged.delegate(to: self) { delegate, result in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .result(let value):
                    delegate.source = value
                }
                delegate.messageTable.reloadData()
                delegate.messageTable.scrollToBottom(animated: true)
            }
        }
        self.getMessages()
    }

    override func buildUI() {
        self.messageTable.delegate = self
        self.messageTable.dataSource = self
        self.messageTable.separatorStyle = .none

        self.messageTable.register(MessageTableViewCell.self)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MessageViewController.handleRefresh(_:)),
        for: UIControl.Event.valueChanged)
        refreshControl.tintColor = ChatResources.styleColor
        sendBackground.backgroundColor = ChatResources.styleColor
        self.messageTable.backgroundColor = ChatResources.whiteColor
        self.sendButton.backgroundColor = ChatResources.styleColor
        self.sendButton.tintColor = ChatResources.whiteColor
        self.messageTable.addSubview(refreshControl)
    }
}

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

fileprivate extension MessageViewController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getMessages()
        refreshControl.endRefreshing()
    }
}

fileprivate extension MessageViewController {
    func getMessages() {
        self.messagesLoader.getChatMessages()
    }
}
