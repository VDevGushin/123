//
//  ChatStyle.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 31/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
typealias Decoration<T> = (T) -> Void
typealias TableDecoration = (UITableView, _ delegate: UITableViewDelegate&UITableViewDataSource, _ cellType: UITableViewCell.Type) -> Void


final class ChatStyle {
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

    static let tableView: TableDecoration = {
        (_ table: UITableView, delegate: UITableViewDelegate&UITableViewDataSource, cellType: UITableViewCell.Type) -> Void in
        table.registerNib(cellType)
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



