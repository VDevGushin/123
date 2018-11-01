//
//  ChatsViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ChatsViewController: ChatBaseViewController, IPullToRefresh {
    @IBOutlet private weak var chatsTable: UITableView!
    private lazy var chatLoader = ChatsWorker()
    private var source = [Chat]()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(navigator: ChatCoordinator) {
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: "Чаты", nibName: String(describing: ChatsViewController.self), bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navigator.chatCreated {
            navigator.chatCreated.toggle()
            self.getChats()
        }
    }

    override func buildUI() {
        ChatStyle.tableView(self.chatsTable, self, [ChatTableViewCell.self])
        let closeButton = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(closeChat))
        self.navigationItem.leftBarButtonItems = [closeButton]
        let addChatButton = UIBarButtonItem(title: "Новый чат", style: .done, target: self, action: #selector(addChat))
        self.navigationItem.rightBarButtonItems = [addChatButton]
    }

    private func getChats() {
        self.source.removeAll()
        chatLoader.getAllChats { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .result(let result):
                    self?.source = result
                    self?.chatsTable.reloadData()
                }
            }
        }
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getChats()
        self.chatsTable.reloadData()
        refreshControl.endRefreshing()
    }

    @objc private func closeChat() {
        self.navigator.close()
    }

    @objc private func addChat() {
        self.navigator.navigate(to: .createChat)
    }
}

// MARK: - Table view delegate
extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ChatTableViewCell.self, indexPath: indexPath)!
        cell.setChat(with: self.source[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = Array(self.source)[indexPath.item]
        self.navigator.navigate(to: .chatMessages(chat: chat))
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
