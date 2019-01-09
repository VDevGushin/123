//
//  LibraryRootTableViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 26/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

let MovieData = [
    ["title": "Jason Bourne", "cast": "Matt Damon, Alicia Vikander, Julia Stiles", "genre": "action"],
    ["title": "Suicide Squad", "cast": "Margot Robbie, Jared Leto, Will Smith", "genre": "action"],
    ["title": "Star Trek Beyond", "cast": "Chris Pine, Zachary Quinto, Zoe Saldana", "genre": "action"],
    ["title": "Deadpool", "cast": "Ryan Reynolds, Morena Baccarin, Gina Carano", "genre": "action"],
    ["title": "London Has Fallen", "cast": "Gerard Butler, Aaron Eckhart, Morgan Freeman, Angela Bassett", "genre": "action"],
    ["title": "Ghostbusters", "cast": "Kate McKinnon, Leslie Jones, Melissa McCarthy, Kristen Wiig", "genre": "comedy"],
    ["title": "Central Intelligence", "cast": "Dwayne Johnson, Kevin Hart", "genre": "comedy"],
    ["title": "Bad Moms", "cast": "Mila Kunis, Kristen Bell, Kathryn Hahn, Christina Applegate", "genre": "comedy"],
    ["title": "Keanu", "cast": "Jordan Peele, Keegan-Michael Key", "genre": "comedy"],
    ["title": "Neighbors 2: Sorority Rising", "cast": "Seth Rogen, Rose Byrne", "genre": "comedy"],
    ["title": "The Shallows", "cast": "Blake Lively", "genre": "drama"],
    ["title": "The Finest Hours", "cast": "Chris Pine, Casey Affleck, Holliday Grainger", "genre": "drama"],
    ["title": "10 Cloverfield Lane", "cast": "Mary Elizabeth Winstead, John Goodman, John Gallagher Jr.", "genre": "drama"],
    ["title": "A Hologram for the King", "cast": "Tom Hanks, Sarita Choudhury", "genre": "drama"],
    ["title": "Miracles from Heaven", "cast": "Jennifer Garner, Kylie Rogers, Martin Henderson", "genre": "drama"],
]

class LibraryRootTableViewController: UITableViewController, LibraryContentHeaderDelegate, UISearchBarDelegate {
    private let header = LibraryContentHeader(frame: .zero)
    private var searchController = SearchController(searchResultsController: nil)

    enum TableSection: Int {
        case action = 0, comedy, drama, indie, total
    }

    let sectionHeaderHeight: CGFloat = 25.0
    var data = [TableSection: [[String: String]]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.header.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Поиск материлов"
        
        data[.action] = MovieData.filter({ $0["genre"] == "action" })
        data[.comedy] = MovieData.filter({ $0["genre"] == "comedy" })
        data[.drama] = MovieData.filter({ $0["genre"] == "drama" })
        data[.indie] = MovieData.filter({ $0["genre"] == "indie" })

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.title = "Мои материалы"
        // 1. Set table header view programmatically
        self.tableView.setTableHeaderView(headerView: header)
        self.tableView.updateHeaderViewFrame()
        self.tableView.separatorStyle = .none
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.total.rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection] {
            return movieData.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection], movieData.count > 0 {
            return sectionHeaderHeight
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        view.backgroundColor = UIColor(red: 253.0 / 255.0, green: 240.0 / 255.0, blue: 196.0 / 255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .action:
                label.text = "Action"
            case .comedy:
                label.text = "Comedy"
            case .drama:
                label.text = "Drama"
            case .indie:
                label.text = "Indie"
            default:
                label.text = ""
            }
        }
        view.addSubview(label)
        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        // Similar to above, first check if there is a valid section of table.
        // Then we check that for the section there is a row.
        if let tableSection = TableSection(rawValue: indexPath.section), let movie = data[tableSection]?[indexPath.row] {
            cell.textLabel?.text = movie["title"]
        }
        return cell
    }

    func enterText() {
        self.setActiveSearchBar()
        self.tableView.tableHeaderView = nil
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.searchController = nil
        self.tableView.setTableHeaderView(headerView: header)
        self.tableView.updateHeaderViewFrame()
    }

    private func setActiveSearchBar() {
        if #available(iOS 9.1, *) { self.searchController.obscuresBackgroundDuringPresentation = false }
        self.searchController.searchBar.sizeToFit()
        self.definesPresentationContext = true
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        self.searchController.isActive = true
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

}


extension UITableView {

    /// Set table header view & add Auto layout.
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Set first.
        self.tableHeaderView = headerView

        // Then setup AutoLayout.
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }

    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = self.tableHeaderView else { return }

        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
        let header = self.tableHeaderView
        self.tableHeaderView = header
    }
}

class SearchController: UISearchController, UISearchBarDelegate {
    private var customSearchBar = SearchBar(frame: .zero)
    override var searchBar: UISearchBar { return customSearchBar }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SearchBar: UISearchBar {
    var cancelAction: () -> Void = { }
    private enum SubviewKey: String {
        case searchField, clearButton, cancelButton, placeholderLabel
    }
    
    // Button/Icon images
    public var clearButtonImage: UIImage?
    public var resultsButtonImage: UIImage?
    public var searchImage: UIImage?
    
    // Button/Icon colors
    public var searchIconColor: UIColor?
    public var clearButtonColor: UIColor?
    public var cancelButtonColor: UIColor?
    public var capabilityButtonColor: UIColor?
    
    // Text
    public var textColor: UIColor?
    public var placeholderColor: UIColor?
    public var cancelTitle: String?
    
    // Cancel button to change the appearance.
    public var cancelButton: UIButton? {
        guard showsCancelButton else { return nil }
        return self.value(forKey: SubviewKey.cancelButton.rawValue) as? UIButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.showsCancelButton = true
        if let cancelColor = cancelButtonColor {
            self.cancelButton?.setTitleColor(cancelColor, for: .normal)
        }
        self.cancelButton?.setTitle("Отмена", for: .normal)
        self.cancelButton?.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        guard let textField = self.value(forKey: SubviewKey.searchField.rawValue) as? UITextField else { return }
        
        if let clearButton = textField.value(forKey: SubviewKey.clearButton.rawValue) as? UIButton {
            update(button: clearButton, image: clearButtonImage, color: clearButtonColor)
        }
        if let resultsButton = textField.rightView as? UIButton {
            update(button: resultsButton, image: resultsButtonImage, color: capabilityButtonColor)
        }
        if let searchView = textField.leftView as? UIImageView {
            searchView.image = (searchImage ?? searchView.image)?.withRenderingMode(.alwaysTemplate)
            guard let color = searchIconColor else { return }
            searchView.tintColor = color
        }
        if let placeholderLabel = textField.value(forKey: SubviewKey.placeholderLabel.rawValue) as? UILabel,
            let color = placeholderColor {
            placeholderLabel.textColor = color
        }
        if let textColor = textColor {
            textField.textColor = textColor
        }
    }
    
    @objc func cancel() {
        self.cancelAction()
    }
    
    private func update(button: UIButton, image: UIImage?, color: UIColor?) {
        let image = (image ?? button.currentImage)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        if let color = color {
            button.tintColor = color
        }
    }
}
