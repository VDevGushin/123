//
//  IPullToRefresh.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 31/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

@objc protocol IPullToRefresh {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
}
