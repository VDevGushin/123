//
//  Common.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public typealias Decoration<T> = (T) -> Void
public typealias DecorationWithColor<T> = (T, UIColor) -> Void
public typealias TableDecoration = (UITableView, _ delegate: UITableViewDelegate&UITableViewDataSource, _ cellTypes: [UITableViewCell.Type]) -> Void
public typealias SearchControllerDecoration = (UISearchController, _ delegate: UISearchResultsUpdating) -> Void

@objc public protocol IPullToRefresh {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
}
