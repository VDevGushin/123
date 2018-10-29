//
//  MessagesTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    private let chat: Chat
    private let messagesLoader: ChatMessagesLoader
    private var source = Set<Message>()

    init(chat: Chat) {
        self.chat = chat
        self.messagesLoader = ChatMessagesLoader(chatId: self.chat.id)
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: String(describing: MessagesTableViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.messagesLoader.sourceChanged.delegate(to: self) { delegate, result in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .result(let value):
                    delegate.source = value
                }
                delegate.tableView.reloadData()
            }
        }
        self.getMessages()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: MessageCell.self, indexPath: indexPath)!
        cell.setMessage(message: self.source.getElement(index: indexPath.item))
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        return cell
    }
}

fileprivate extension MessagesTableViewController {
    func setupUI() {
        self.tableView.registerWithClass(MessageCell.self)
        self.refreshControl = UIRefreshControl()
        self.tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: self.tableView.bounds.size.width - 8.0)
        self.refreshControl?.addTarget(self, action:
            #selector(MessagesTableViewController.handleRefresh(_:)),
        for: UIControl.Event.valueChanged)
        self.refreshControl?.tintColor = UIColor.red
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.messagesLoader.refresh()
        refreshControl.endRefreshing()
    }
}

fileprivate extension MessagesTableViewController {
    func getMessages() {
        self.messagesLoader.getChatMessages()
    }
}
/*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

/*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

/*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

/*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

/*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
