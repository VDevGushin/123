//
//  ChatsTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class ChatsTableViewController: UITableViewController {
    private lazy var chatLoader = ChatsLoader()
    private var source = Set<Chat>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getChats()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ChatCell.self, indexPath: indexPath)!
        cell.setChat(with: self.source.getElement(index: indexPath.item))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = Array(self.source)[indexPath.item]
        let vc = MessagesTableViewController(chat: chat)
        self.present(vc, animated: true, completion: nil)
    }
}

fileprivate extension ChatsTableViewController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getChats()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func setupUI() {
        self.tableView.registerWithClass(ChatCell.self)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:
            #selector(ChatsTableViewController.handleRefresh(_:)),
        for: UIControl.Event.valueChanged)
        self.refreshControl?.tintColor = UIColor.red
    }
}

fileprivate extension ChatsTableViewController {
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
                    self?.tableView.reloadData()
                }
            }
        }
    }
}
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

