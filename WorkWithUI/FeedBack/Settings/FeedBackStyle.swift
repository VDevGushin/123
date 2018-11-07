//
//  FeedBackStyle.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class FeedBackStyle {
    static let indicator: Decoration<UIActivityIndicatorView> = { (indicator: UIActivityIndicatorView) -> Void in
        indicator.color = FeedBackConfig.indicatorColor
    }
    
    static let titleLabel: Decoration<UILabel> = { (label: UILabel) -> Void in
        label.font = FeedBackConfig.titleFont
        label.numberOfLines = 3
        label.textColor = FeedBackConfig.textColor
    }

    static let tableView: TableDecoration = { (_ table: UITableView, delegate: UITableViewDelegate&UITableViewDataSource, cellTypes: [UITableViewCell.Type]) -> Void in
        cellTypes.forEach {
            table.registerNib($0)
        }

        table.delegate = delegate
        table.dataSource = delegate
        table.separatorStyle = .none
        table.backgroundColor = FeedBackConfig.whiteColor

        if let delegate = delegate as? IPullToRefresh {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(delegate, action: #selector(delegate.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = FeedBackConfig.styleColor
            table.addSubview(refreshControl)
        }
    }
    
    static let serachController: SearchControllerDecoration = { (_ serachController: UISearchController, delegate: UISearchResultsUpdating) -> Void in
        serachController.searchResultsUpdater = delegate
        serachController.hidesNavigationBarDuringPresentation = false
        serachController.dimsBackgroundDuringPresentation = false
        serachController.searchBar.barTintColor = FeedBackConfig.styleColor
        serachController.searchBar.searchBarStyle = .default
        serachController.searchBar.sizeToFit()
        
        if let textfield = serachController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = FeedBackConfig.whiteColor
            textfield.layer.cornerRadius = 16.0
            textfield.clearButtonMode = UITextField.ViewMode.whileEditing
            textfield.borderStyle = UITextField.BorderStyle.roundedRect
            textfield.layer.masksToBounds = true
            textfield.layer.borderColor = FeedBackConfig.styleColor.cgColor
            textfield.layer.borderWidth = 1.5
            textfield.textColor = .red
        }
    }
}
