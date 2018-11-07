//
//  ChatStyle.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 31/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class ChatStyle {
    static let serachController: SearchControllerDecoration = { (_ serachController: UISearchController, delegate: UISearchResultsUpdating) -> Void in
        serachController.searchResultsUpdater = delegate
        serachController.hidesNavigationBarDuringPresentation = false
        serachController.dimsBackgroundDuringPresentation = false
        serachController.searchBar.barTintColor = ChatResources.styleColor
        serachController.searchBar.searchBarStyle = .default
        serachController.searchBar.sizeToFit()

        if let textfield = serachController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = ChatResources.whiteColor
            textfield.layer.cornerRadius = 16.0
            textfield.clearButtonMode = UITextField.ViewMode.whileEditing
            textfield.borderStyle = UITextField.BorderStyle.roundedRect
            textfield.layer.masksToBounds = true
            textfield.layer.borderColor = ChatResources.styleColor.cgColor
            textfield.layer.borderWidth = 1.5
            textfield.textColor = .red
        }
    }

    static let messageText: Decoration<UILabel> = { (label: UILabel) -> Void in
        label.font = ChatResources.titleFont
        label.numberOfLines = 0
        label.textColor = ChatResources.textColor
    }

    static let titleLabel: Decoration<UILabel> = { (label: UILabel) -> Void in
        label.font = ChatResources.titleFont
        label.numberOfLines = 3
        label.textColor = ChatResources.textColor
    }

    static let subTitleLabel: Decoration<UILabel> = { (label: UILabel) -> Void in
        label.font = ChatResources.subTitleFont
        label.numberOfLines = 1
        label.textColor = ChatResources.subTextColor
    }

    static let messageBackView: DecorationWithColor<UIView> = { (view: UIView, color: UIColor) -> Void in
        view.layer.cornerRadius = 12
        view.backgroundColor = color
    }

    static let defaultBackground: Decoration<UIView> = { (view: UIView) -> Void in
        view.backgroundColor = ChatResources.styleColor
    }

    static let sendButton: Decoration<UIButton> = { (button: UIButton) -> Void in
        button.backgroundColor = ChatResources.styleColor
        button.tintColor = ChatResources.whiteColor
    }

    static let navigationBar: Decoration<UINavigationBar> = { (navigationBar: UINavigationBar) -> Void in
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = ChatResources.styleColor
        navigationBar.tintColor = ChatResources.whiteColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ChatResources.whiteColor]
    }

    static let tableView: TableDecoration = { (_ table: UITableView, delegate: UITableViewDelegate&UITableViewDataSource, cellTypes: [UITableViewCell.Type]) -> Void in
        cellTypes.forEach {
            table.registerNib($0)
        }

        table.delegate = delegate
        table.dataSource = delegate
        table.separatorStyle = .none
        table.backgroundColor = ChatResources.whiteColor

        if let delegate = delegate as? IPullToRefresh {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(delegate, action: #selector(delegate.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = ChatResources.styleColor
            table.addSubview(refreshControl)
        }
    }
}



