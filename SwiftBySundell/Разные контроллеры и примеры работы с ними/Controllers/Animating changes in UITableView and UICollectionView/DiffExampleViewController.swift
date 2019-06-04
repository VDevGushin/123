//
//  DiffExampleViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 14/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class DiffExampleViewController: CoordinatorViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    @IBOutlet weak var collection: UICollectionView!
    private var commonSource = ["Apple", "Orange", "Tomato", "Sosage", "Akronis", "Apple", "Orange", "Tomato", "Sosage", "Akronis", "Apple", "Orange", "Tomato", "Sosage", "Akronis"]
    private var dataSource: [String] = []
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.dataSource = self
        self.collection.delegate = self
        self.collection.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")

        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self

        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for tools and resources"
        searchController.searchBar.sizeToFit()

        searchController.searchBar.becomeFirstResponder()

        self.dataSource = commonSource
        self.navigationItem.titleView = searchController.searchBar
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.textLabel.text = self.dataSource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.dataSource[indexPath.row]
        let cellWidth = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12.0)]).width + 30.0
        return CGSize(width: cellWidth, height: 30.0)
    }

    func render(_ newData: [String]) {
        let oldData = dataSource
        dataSource = newData
        collection.reloadChanges(from: oldData, to: newData)
    }
}

//MARK: Search Bar
extension DiffExampleViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.render(commonSource)
        self.dismiss(animated: true, completion: nil)
    }

    func updateSearchResults(for searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text

        let filtered = commonSource.filter({ (item) -> Bool in
            let countryText: NSString = item as NSString
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        if filtered.count > 0 {
            self.render(filtered)
        } else {
            self.render(commonSource)
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collection.reloadData()
    }


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        collection.reloadData()
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
//        if !searchActive {
//            searchActive = true
//            collection.reloadData()
//        }
        searchController.searchBar.resignFirstResponder()
    }
}
