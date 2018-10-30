//
//  ChatsViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 30/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ChatsViewController: ChatBaseViewController {
    @IBOutlet private weak var chatsTable: UITableView!
    private lazy var chatLoader = ChatsWorker()
    private var source = Set<Chat>()

    init(navigator: ChatCoordinator) {
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: "Чаты", nibName: String(describing: ChatsViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getChats()
    }

    override func buildUI() {
        self.chatsTable.registerWithClass(ChatCell.self)
        self.chatsTable.delegate = self
        self.chatsTable.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ChatsViewController.handleRefresh(_:)),
        for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        self.chatsTable.addSubview(refreshControl)

        let button1 = UIBarButtonItem.init(title: "Close", style: .done, target: self,
                                           action: #selector(closeChat))

        self.navigationItem.leftBarButtonItems = [button1]
    }
}

fileprivate extension ChatsViewController {
    func getChats() {
        self.source.removeAll()
        chatLoader.getAllChats { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .result(let result):
                    for chat in result {
                        self?.source.insert(chat)
                    }
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
    
    @objc func closeChat() {
        self.navigator.close()
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ChatCell.self, indexPath: indexPath)!
        cell.setChat(with: self.source.getElement(index: indexPath.item))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = Array(self.source)[indexPath.item]
        self.navigator.navigate(to: .chatMessages(chat: chat))
    }
}
