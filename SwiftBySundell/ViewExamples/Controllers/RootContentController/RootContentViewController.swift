//
//  RootContentViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 12/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit



class RootContentViewController: CoordinatorViewController {

    @IBOutlet weak var contentHeader: UITableView!
    var arr = ["Basic Operators", "Strings and Characters", "Collection Types", "Control Flow", "Structures and Classes", "Optional Chaining", "Closures", "Automatic Reference Counting", "Advanced Operators", "Access Control", "Memory Safety", "Generics", "Protocols", "Extensions", "Type Casting", "Nested Types", "Error Handling", "Deinitialization"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        contentHeader.delegate = self
        contentHeader.dataSource = self
        // Do any additional setup after loading the view.
        self.contentHeader.register(UINib.init(nibName: "RootContentTableViewCell", bundle: nil), forCellReuseIdentifier: "RootContentTableViewCell")
        let nibName = UINib(nibName: "DemoHeaderView", bundle: nil)
        self.contentHeader.register(nibName, forHeaderFooterViewReuseIdentifier: "DemoHeaderView")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RootContentViewController: UITableViewDelegate {

}

extension RootContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as! DemoHeaderView
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RootContentTableViewCell", for: indexPath) as! RootContentTableViewCell
        cell.configure(with: self.arr)
        return cell
    }
}
